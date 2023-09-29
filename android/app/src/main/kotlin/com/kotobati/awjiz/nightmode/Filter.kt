package com.kotobati.awjiz.nightmode

interface Filter {
    fun onCreate()
    fun onDestroy()
    var profile: Profile
}
