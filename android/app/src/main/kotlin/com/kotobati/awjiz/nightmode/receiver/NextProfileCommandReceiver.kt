package com.kotobati.awjiz.nightmode.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.kotobati.awjiz.nightmode.ProfilesModel
import com.kotobati.awjiz.nightmode.activeProfile
import com.kotobati.awjiz.nightmode.helper.Logger


class NextProfileCommandReceiver : BroadcastReceiver() {

    companion object : Logger()

    override fun onReceive(context: Context, intent: Intent) {
        Log.i("Next profile requested")
        activeProfile = ProfilesModel.profileAfter(activeProfile)
    }
}
