package com.kotobati.awjiz.nightmode

import com.kotobati.awjiz.nightmode.helper.KLogging


private const val WHITELIST_PREF: String = "com.kotobati.awjiz.WHITELIST"

object Whitelist : Preferences(appContext, WHITELIST_PREF) {

    private val _model: Map<String, Set<String>>
        get() = prefs.all.mapValues { (_, v) -> v as Set<String> }

    private var modelOutdated: Boolean = true

    private var model: Map<String, Set<String>> = _model
        get() {
            if (modelOutdated) {
                field = _model
                modelOutdated = false
            }
            return field
        }

    fun add(app: App) {
        Log.i("Adding $app to WL")
        var activities by StringSetPreference(app.packageName, emptySet<String>())
        activities = activities.plus(app.className)
        modelOutdated = true
    }

    fun contains(app: App): Boolean? {
        val activities = model[app.packageName]
        val onWL = activities?.contains(app.className)
        Log.i("On WL? $onWL -- app: $app")
        return onWL
    }

    fun remove(app: App) {
        Log.i("Removing $app from WL")
        var appActivites by StringSetPreference(app.packageName, emptySet<String>())
        val temp = appActivites.minus(app.className)
        appActivites = temp
        modelOutdated = true
    }

    private val Log = KLogging.logger("Whitelist")
}
