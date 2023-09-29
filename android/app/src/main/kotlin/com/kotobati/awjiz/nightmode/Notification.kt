package com.kotobati.awjiz.nightmode

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.kotobati.awjiz.MainActivity
import com.kotobati.awjiz.R
import com.kotobati.awjiz.nightmode.helper.Logger
import com.kotobati.awjiz.nightmode.manager.CurrentAppMonitor
import com.kotobati.awjiz.nightmode.receiver.NextProfileCommandReceiver
import com.kotobati.awjiz.nightmode.receiver.WhitelistChangeReceiver


class Notification(
    private val context: Context,
    private val appMonitor: CurrentAppMonitor
) {

    private val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE)
            as NotificationManager

    fun build(isOn: Boolean): Notification {
        // Register a notification channel for Oreo if we don't already have one
        val channelID = getString(R.string.notification_channel_overlay_id)
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O
            && notificationManager.getNotificationChannel(channelID) == null
        ) {
            val channelName = getString(R.string.notification_channel_overlay_name)
            val channelDescription = getString(R.string.notification_channel_overlay_description)
            val channel =
                NotificationChannel(channelID, channelName, NotificationManager.IMPORTANCE_MIN)
            channel.description = channelDescription
            notificationManager.createNotificationChannel(channel)
        }

        return NotificationCompat.Builder(
            context,
            getString(R.string.notification_channel_overlay_id)
        ).apply {
            // Set notification appearance
            setSmallIcon(R.mipmap.ic_launcher)
            color = ContextCompat.getColor(appContext, R.color.color_primary)
            priority = NotificationCompat.PRIORITY_MIN

            if (belowAPI(24)) {
                setContentTitle(getString(R.string.app_name))
            }
            setSubText(activeProfile.name)

            // Open Red Moon when tapping notification body
            val mainIntent = intent(MainActivity::class).apply {
                flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
            }
            setContentIntent(activityPI(ACTION_SETTINGS, mainIntent))

            addAction(
                R.drawable.ic_stop, R.string.notification_action_stop,
                servicePI(ACTION_STOP, Command.OFF.intent)
            )

            if (isOn) {
                setContentText(getString(R.string.notification_status_running))
                if (appMonitor.monitoring) {
                    val addWL = WhitelistChangeReceiver.intent(true)
                    addAction(
                        R.drawable.ic_pause, R.string.notification_action_whitelist_add,
                        broadcastPI(ACTION_WHITELIST, addWL)
                    )
                } else {
                    addAction(
                        R.drawable.ic_pause, R.string.notification_action_pause,
                        servicePI(ACTION_TOGGLE, Command.PAUSE.intent)
                    )
                }
            } else {
                setContentText(getString(R.string.notification_status_paused))
                if (appMonitor.monitoring) {
                    val rmWL = WhitelistChangeReceiver.intent(false)
                    addAction(
                        R.drawable.ic_play, R.string.notification_action_whitelist_remove,
                        broadcastPI(ACTION_UNWHITELIST, rmWL)
                    )
                } else {
                    addAction(
                        R.drawable.ic_play, R.string.notification_action_resume,
                        servicePI(ACTION_TOGGLE, Command.ON.intent)
                    )
                }
            }

            val nextProfileIntent = intent(NextProfileCommandReceiver::class)
            addAction(
                R.drawable.ic_skip_next,
                R.string.notification_action_next_filter,
                broadcastPI(NEXT_PROFILE, nextProfileIntent)
            )
        }.build()
    }

    //region wrappers for readability
    @SuppressLint("UnspecifiedImmutableFlag")
    private fun servicePI(code: Int, intent: Intent) =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
            PendingIntent.getService(
                context, code, intent, PendingIntent.FLAG_UPDATE_CURRENT.or(
                    PendingIntent.FLAG_IMMUTABLE
                )
            )
        else
            PendingIntent.getService(context, code, intent, PendingIntent.FLAG_UPDATE_CURRENT)


    @SuppressLint("UnspecifiedImmutableFlag")
    private fun activityPI(code: Int, intent: Intent) =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
            PendingIntent.getActivity(
                context, code, intent, PendingIntent.FLAG_UPDATE_CURRENT.or(
                    PendingIntent.FLAG_IMMUTABLE
                )
            )
        else
            PendingIntent.getActivity(context, code, intent, PendingIntent.FLAG_UPDATE_CURRENT)

    @SuppressLint("UnspecifiedImmutableFlag")
    private fun broadcastPI(code: Int, intent: Intent) =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
            PendingIntent.getBroadcast(context, code, intent, PendingIntent.FLAG_IMMUTABLE)
        else
            PendingIntent.getBroadcast(context, code, intent, 0)

    private fun NotificationCompat.Builder.addAction(icon: Int, title: Int, intent: PendingIntent) =
        addAction(icon, getString(title), intent)
    //endregion

    companion object : Logger() {
        // Request codes
        private const val ACTION_SETTINGS = 1000
        private const val ACTION_TOGGLE = 3000
        private const val NEXT_PROFILE = 4000
        private const val ACTION_STOP = 5000
        private const val ACTION_WHITELIST = 6000
        private const val ACTION_UNWHITELIST = 7000
    }
}
