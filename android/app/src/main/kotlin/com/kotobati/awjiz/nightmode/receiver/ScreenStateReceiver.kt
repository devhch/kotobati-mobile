package com.kotobati.awjiz.nightmode.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.kotobati.awjiz.nightmode.helper.Logger

class ScreenStateReceiver(private val mListener: ScreenStateListener?) : BroadcastReceiver() {

    companion object : Logger()

    interface ScreenStateListener {
        fun onScreenTurnedOn()
        fun onScreenTurnedOff()
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.i("Intent received")

        if (Intent.ACTION_SCREEN_ON == intent.action) {
            Log.i("Screen turned on")

            mListener?.onScreenTurnedOn()
        } else if (Intent.ACTION_SCREEN_OFF == intent.action) {
            Log.i("Screen turned off")

            mListener?.onScreenTurnedOff()
        }
    }
}
