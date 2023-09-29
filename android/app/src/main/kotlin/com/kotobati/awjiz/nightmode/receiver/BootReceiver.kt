package com.kotobati.awjiz.nightmode.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.kotobati.awjiz.nightmode.Command
import com.kotobati.awjiz.nightmode.Config
import com.kotobati.awjiz.nightmode.helper.KLog
import com.kotobati.awjiz.nightmode.helper.Logger
import com.kotobati.awjiz.nightmode.inActivePeriod
import com.kotobati.awjiz.nightmode.manager.BrightnessManager


class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        Log.i("Boot broadcast received!")

        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            // If the filter was on when the device was powered down and the
            // automatic brightness setting is on, then it still uses the
            // dimmed brightness and we need to restore the saved brightness.
            BrightnessManager(context).brightnessLowered = false

            ScheduleReceiver.scheduleNextOnCommand()
            ScheduleReceiver.scheduleNextOffCommand()

            Command.toggle(filterIsOnPrediction(Log))
        }
    }

    companion object : Logger()
}

class TimeZoneChangeReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        Log.i("System time zone change broadcast received!")

        if (intent.action == Intent.ACTION_TIMEZONE_CHANGED) {
            ScheduleReceiver.rescheduleOnCommand()
            ScheduleReceiver.rescheduleOffCommand()
            Command.toggle(filterIsOnPrediction(Log))
        }
    }

    companion object : Logger()
}

fun filterIsOnPrediction(Log: KLog): Boolean {
    // If schedule is not enabled, restore the previous state before shutdown
    return if (Config.scheduleOn) inActivePeriod(Log) else Config.filterIsOn
}
