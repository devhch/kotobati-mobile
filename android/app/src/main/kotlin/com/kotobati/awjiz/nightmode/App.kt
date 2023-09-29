package com.kotobati.awjiz.nightmode

data class App(val packageName: String, val className: String) {
    // TODO: check activity names
    val isWhitelisted: Boolean
        get() = Whitelist.contains(this) ?: when (packageName) {
            "eu.chainfire.supersu",
            "com.koushikdutta.superuser",
            "me.phh.superuser",
            "com.google.android.packageinstaller",
            "com.owncloud.android" -> true

            "com.android.packageinstaller" ->
                className == "com.android.packageinstaller.PackageInstallerActivity"

            else -> false
        }
}
