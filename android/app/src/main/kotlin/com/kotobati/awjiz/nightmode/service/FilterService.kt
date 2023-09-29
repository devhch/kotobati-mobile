package com.kotobati.awjiz.nightmode.service

import android.animation.ValueAnimator
import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.widget.Toast
import com.kotobati.awjiz.R
import com.kotobati.awjiz.nightmode.Command
import com.kotobati.awjiz.nightmode.CommandAnimatorListener
import com.kotobati.awjiz.nightmode.Config
import com.kotobati.awjiz.nightmode.EventBus
import com.kotobati.awjiz.nightmode.Filter
import com.kotobati.awjiz.nightmode.Notification
import com.kotobati.awjiz.nightmode.Overlay
import com.kotobati.awjiz.nightmode.Profile
import com.kotobati.awjiz.nightmode.ProfileEvaluator
import com.kotobati.awjiz.nightmode.activeProfile
import com.kotobati.awjiz.nightmode.filterIsOn
import com.kotobati.awjiz.nightmode.helper.Logger
import com.kotobati.awjiz.nightmode.helper.Permission
import com.kotobati.awjiz.nightmode.manager.CurrentAppMonitor
import com.kotobati.awjiz.nightmode.manager.Surfaceflinger
import com.kotobati.awjiz.nightmode.overlayPermissionDenied
import com.kotobati.awjiz.nightmode.secureSuspendChanged

import com.topjohnwu.superuser.Shell
import org.greenrobot.eventbus.Subscribe
import java.util.concurrent.Executors

class FilterService : Service() {

    private lateinit var mFilter: Filter
    private lateinit var mAnimator: ValueAnimator
    private lateinit var mCurrentAppMonitor: CurrentAppMonitor
    private lateinit var mNotification: Notification
    private val executor = Executors.newSingleThreadScheduledExecutor()

    override fun onCreate() {
        super.onCreate()
        Log.i("onCreate")
        if (Config.useRoot) {
            Log.i("Starting in root mode")
            mFilter = Surfaceflinger()
        } else {
            Log.i("Starting in overlay mode")
            mFilter = Overlay(this)
        }
        mCurrentAppMonitor = CurrentAppMonitor(this, executor)
        mNotification = Notification(this, mCurrentAppMonitor)
        mAnimator = ValueAnimator.ofObject(ProfileEvaluator(), mFilter.profile).apply {
            addUpdateListener { valueAnimator ->
                mFilter.profile = valueAnimator.animatedValue as Profile
            }
        }
        startForeground(NOTIFICATION_ID, mNotification.build(false))
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        Log.i("onStartCommand($intent, $flags, $startId)")
        fun fadeInOrOut() {
            val cmd = Command.getCommand(intent)
            val end = if (cmd.turnOn) activeProfile else mFilter.profile.off
            mAnimator.run {
                setObjectValues(mFilter.profile, end)
                val fraction = if (isRunning) animatedFraction else 1f
                duration = (cmd.time * fraction).toLong()
                removeAllListeners()
                addListener(CommandAnimatorListener(cmd, this@FilterService))
                Log.i("Animating from ${mFilter.profile} to $end in $duration")
                start()
            }
        }
        if (Config.useRoot) {
            val hasRoot = Shell.rootAccess()
            if (hasRoot) {
                fadeInOrOut()
            } else {
                Log.i("Root permission denied. Disabling root mode.")
                Toast.makeText(this, R.string.toast_root_unavailable, Toast.LENGTH_SHORT).show()
                Config.useRoot = false;
                stopForeground(false)
            }
        } else {
            if (Permission.Overlay.isGranted) {
                fadeInOrOut()
            } else {
                Log.i("Overlay permission denied.")
                EventBus.post(overlayPermissionDenied())
                stopForeground(false)
            }
        }

        // Do not attempt to restart if the hosting process is killed by Android
        return Service.START_NOT_STICKY
    }

    fun start(isOn: Boolean) {
        if (!filterIsOn) {
            EventBus.register(this)
            filterIsOn = true
            mCurrentAppMonitor.monitoring = Config.secureSuspend
        }
        startForeground(NOTIFICATION_ID, mNotification.build(isOn))
    }

    override fun onDestroy() {
        Log.i("onDestroy")
        EventBus.unregister(this)
        if (filterIsOn) {
            Log.w("Service killed while filter was on!")
            filterIsOn = false
            mCurrentAppMonitor.monitoring = false
        }
        mFilter.onDestroy()
        executor.shutdownNow()
        super.onDestroy()
    }

    @Subscribe
    fun onProfileUpdated(profile: Profile) {
        mFilter.profile = profile
        startForeground(NOTIFICATION_ID, mNotification.build(true))
    }

    @Subscribe
    fun onSecureSuspendChanged(event: secureSuspendChanged) {
        mCurrentAppMonitor.monitoring = Config.secureSuspend
    }

    override fun onBind(intent: Intent): IBinder? = null // Prevent binding.

    companion object : Logger() {
        private const val NOTIFICATION_ID = 1
    }
}
