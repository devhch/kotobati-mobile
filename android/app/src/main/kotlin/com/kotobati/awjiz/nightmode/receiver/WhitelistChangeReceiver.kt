package com.kotobati.awjiz.nightmode.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.kotobati.awjiz.nightmode.Command
import com.kotobati.awjiz.nightmode.Whitelist
import com.kotobati.awjiz.nightmode.helper.Logger
import com.kotobati.awjiz.nightmode.intent
import com.kotobati.awjiz.nightmode.manager.CurrentAppMonitor


class WhitelistChangeReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.getStringExtra(EXTRA_ACTION)
        val app = CurrentAppMonitor.currentApp
        when (action) {
            ACTION_ADD -> {
                Whitelist.add(app)
                Command.PAUSE.send()
            }

            ACTION_REMOVE -> {
                Whitelist.remove(app)
                Command.RESUME.send()
            }
        }
    }

    companion object : Logger() {
        fun intent(add: Boolean): Intent {
            return intent(WhitelistChangeReceiver::class).apply {
                putExtra(EXTRA_ACTION, if (add) ACTION_ADD else ACTION_REMOVE)
            }
        }

        private const val EXTRA_ACTION = "kotobati.bundle.key.wlAction"
        private const val ACTION_ADD = "add"
        private const val ACTION_REMOVE = "remove"
    }
}
