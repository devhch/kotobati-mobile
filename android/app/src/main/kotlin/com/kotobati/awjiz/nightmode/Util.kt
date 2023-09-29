package com.kotobati.awjiz.nightmode

import android.content.Intent
import androidx.preference.Preference
import androidx.core.content.ContextCompat
import androidx.preference.PreferenceFragmentCompat
import com.kotobati.awjiz.nightmode.helper.KLog
import com.kotobati.awjiz.nightmode.helper.KLogging


import java.util.Calendar

import kotlin.reflect.KClass

val appContext = ReadingModeApplication.app

var activeProfile: Profile
    get() = EventBus.getSticky(Profile::class) ?: with(Config) {
        Profile(color, intensity, dimLevel, lowerBrightness)
    }
    set(value) = value.let {
        if (it != EventBus.getSticky(Profile::class)) with(Config) {
            val Log = KLogging.logger("Util")
            Log.i("activeProfile set to $it")
            EventBus.postSticky(it)
            color = it.color
            intensity = it.intensity
            dimLevel = it.dimLevel
            lowerBrightness = it.lowerBrightness
        }
    }

var filterIsOn: Boolean = false
    set(value) {
        field = value
        Config.filterIsOn = value
    }

fun inActivePeriod(Log: KLog? = null): Boolean {
    val now = Calendar.getInstance()

    val onTime = Config.scheduledStartTime
    val onHour = onTime.substringBefore(':').toInt()
    val onMinute = onTime.substringAfter(':').toInt()
    val on = Calendar.getInstance().apply {
        set(Calendar.HOUR_OF_DAY, onHour)
        set(Calendar.MINUTE, onMinute)
        if (after(now)) {
            add(Calendar.DATE, -1)
        }
    }

    val offTime = Config.scheduledStopTime
    val offHour = offTime.substringBefore(':').toInt()
    val offMinute = offTime.substringAfter(':').toInt()
    val off = Calendar.getInstance().apply {
        set(Calendar.HOUR_OF_DAY, offHour)
        set(Calendar.MINUTE, offMinute)
        while (before(on)) {
            add(Calendar.DATE, 1)
        }
    }

    Log?.d("Start: $onTime, stop: $offTime")
    Log?.d("On DAY_OF_MONTH: ${on.get(Calendar.DAY_OF_MONTH)}")
    Log?.d("Off DAY_OF_MONTH: ${off.get(Calendar.DAY_OF_MONTH)}")

    return now.after(on) && now.before(off)
}

fun getString(resId: Int): String = appContext.getString(resId)
fun getColor(resId: Int): Int = ContextCompat.getColor(appContext, resId)

fun atLeastAPI(api: Int): Boolean = android.os.Build.VERSION.SDK_INT >= api
fun belowAPI(api: Int): Boolean = android.os.Build.VERSION.SDK_INT < api

fun intent() = Intent()
fun <T : Any> intent(kc: KClass<T>) = Intent(appContext, kc.java)

fun PreferenceFragmentCompat.pref(resId: Int): Preference? {
    return preferenceScreen.findPreference(getString(resId))
}
