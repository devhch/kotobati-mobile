package com.kotobati.awjiz.nightmode

import android.content.Context
import android.graphics.Canvas
import android.view.View
import android.view.WindowManager
import com.kotobati.awjiz.nightmode.helper.Logger
import com.kotobati.awjiz.nightmode.manager.BrightnessManager
import com.kotobati.awjiz.nightmode.manager.ScreenManager
import com.kotobati.awjiz.nightmode.receiver.OrientationChangeReceiver


import kotlin.properties.Delegates

import org.greenrobot.eventbus.Subscribe

class Overlay(context: Context) : View(context), Filter,
    OrientationChangeReceiver.OnOrientationChangeListener {

    private val mWindowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private val mScreenManager = ScreenManager(context, mWindowManager)
    private val mOrientationReceiver = OrientationChangeReceiver(context, this)
    private val mBrightnessManager = BrightnessManager(context)

    override fun onCreate() {
        Log.i("onCreate()")
    }

    override var profile: Profile = activeProfile.off
        set(value) {
            Log.i("profile set to: $value")
            field = value
            filtering = !value.isOff
        }

    override fun onDestroy() {
        Log.i("onDestroy()")
        filtering = false
    }

    private var filtering: Boolean by Delegates.observable(false) { _, isOn, turnOn ->
        when {
            !isOn && turnOn -> show()
            isOn && !turnOn -> hide()
            isOn && turnOn -> update()
        }
    }

    private fun show() {
        updateLayoutParams()
        mWindowManager.addView(this, mLayoutParams)
        mBrightnessManager.brightnessLowered = profile.lowerBrightness
        mOrientationReceiver.register()
        EventBus.register(this)
    }

    private fun hide() {
        mBrightnessManager.brightnessLowered = false
        mWindowManager.removeView(this)
        mOrientationReceiver.unregister()
        EventBus.unregister(this)
    }

    private fun update() {
        invalidate() // Forces call to onDraw
        if (Config.buttonBacklightFlag == "dim") {
            reLayout()
        }
        mBrightnessManager.brightnessLowered = profile.lowerBrightness
    }

    private var mLayoutParams = mScreenManager.layoutParams
        get() = field.apply {
            buttonBrightness = Config.buttonBacklightLevel
            type = if (atLeastAPI(26)) {
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            } else {
                WindowManager.LayoutParams.TYPE_SYSTEM_OVERLAY
            }
        }

    private fun updateLayoutParams() {
        mLayoutParams = mScreenManager.layoutParams
    }

    private fun reLayout() = mWindowManager.updateViewLayout(this, mLayoutParams)

    override fun onDraw(canvas: Canvas) = canvas.drawColor(profile.filterColor)

    override fun onOrientationChanged() {
        updateLayoutParams()
        reLayout()
    }

    @Subscribe
    fun onButtonBacklightChanged(event: buttonBacklightChanged) {
        reLayout()
    }

    companion object : Logger()
}
