package com.kotobati.awjiz.nightmode.manager

import android.content.Context
import android.provider.Settings
import com.kotobati.awjiz.nightmode.Config
import com.kotobati.awjiz.nightmode.EventBus
import com.kotobati.awjiz.nightmode.belowAPI
import com.kotobati.awjiz.nightmode.changeBrightnessDenied
import com.kotobati.awjiz.nightmode.helper.Logger
import com.kotobati.awjiz.nightmode.helper.Permission


class BrightnessManager(private val context: Context) {
    companion object : Logger()

    private val resolver = context.contentResolver

    private var level: Int
        get() = Settings.System.getInt(resolver, Settings.System.SCREEN_BRIGHTNESS)
        set(value) {
            if (belowAPI(23) || Settings.System.canWrite(context)) {
                Settings.System.putInt(resolver, Settings.System.SCREEN_BRIGHTNESS, value)
            } else {
                Log.w("Write settings permission not granted; cannot set brightness")
            }
        }

    private var auto: Boolean
        get() = 1 == Settings.System.getInt(resolver, "screen_brightness_mode")
        set(value) {
            val i = if (value) 1 else 0
            Settings.System.putInt(resolver, "screen_brightness_mode", i)
        }

    var brightnessLowered: Boolean
        get() = Config.brightnessLowered && !auto && (level == 0)
        set(lower) = when {
            !Permission.WriteSettings.isGranted -> {
                Log.i("Permission not granted!")
                EventBus.post(changeBrightnessDenied())
            }

            lower == brightnessLowered -> {
                Log.i("Brightness already raised/lowered")
            }

            lower -> {
                try {
                    Log.i("Saving current brightness")
                    Config.automaticBrightness = auto
                    Config.brightness = level
                    Log.i("Lowering brightness")
                    level = 0
                    auto = false
                    Config.brightnessLowered = true
                } catch (e: Settings.SettingNotFoundException) {
                    Log.e("Error reading brightness state $e")
                }
            }

            else -> {
                Log.i("Restoring brightness")
                auto = Config.automaticBrightness
                level = Config.brightness
                Config.brightnessLowered = false
            }
        }
}
