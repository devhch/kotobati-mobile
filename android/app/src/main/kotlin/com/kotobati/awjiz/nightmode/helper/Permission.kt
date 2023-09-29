package com.kotobati.awjiz.nightmode.helper

import android.Manifest
import android.annotation.TargetApi
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build

import androidx.appcompat.app.AlertDialog
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.kotobati.awjiz.R
import com.kotobati.awjiz.nightmode.Event
import com.kotobati.awjiz.nightmode.EventBus
import com.kotobati.awjiz.nightmode.appContext
import com.kotobati.awjiz.nightmode.atLeastAPI

import android.provider.Settings

private const val REQ_CODE_OVERLAY = 1111
private const val REQ_CODE_LOCATION = 2222
private const val REQ_CODE_SETTINGS = 3333

abstract class PermissionHelper : Event {
    abstract val isGranted: Boolean
    protected abstract val requestCode: Int
    protected abstract fun send(activity: Activity)
    fun request(activity: Activity): Boolean {
        if (!isGranted) {
            send(activity)
        }
        return isGranted
    }
}

object Permission {
    fun onRequestResult(requestCode: Int) {
        EventBus.post(
            when (requestCode) {
                REQ_CODE_OVERLAY -> Overlay
                REQ_CODE_LOCATION -> Location
                REQ_CODE_SETTINGS -> WriteSettings
                else -> return
            }
        )
    }

    object Location : PermissionHelper() {
        override val requestCode: Int = REQ_CODE_LOCATION

        override val isGranted: Boolean
            get() {
                val lp = Manifest.permission.ACCESS_FINE_LOCATION
                val granted = PackageManager.PERMISSION_GRANTED
                return ContextCompat.checkSelfPermission(appContext, lp) == granted
            }

        override fun send(activity: Activity) {
            val permission = arrayOf(Manifest.permission.ACCESS_FINE_LOCATION)
            ActivityCompat.requestPermissions(activity, permission, requestCode)
        }
    }

    abstract class ElevatedPermission : PermissionHelper() {
        abstract val granted: Boolean
        override val isGranted: Boolean
            get() = if (atLeastAPI(23)) granted else true
    }

    object Overlay : ElevatedPermission() {
        override val requestCode: Int = REQ_CODE_OVERLAY
        override val granted: Boolean
            get() = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                Settings.canDrawOverlays(appContext)
            } else {
                false
            }

        var alertExists = false;

        override @TargetApi(23)
        fun send(activity: Activity) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:" + activity.packageName)
            )
            if (!alertExists) {
                // Ensure only one alert will exist at a time
                alertExists = true;
                AlertDialog.Builder(activity).run {
                    setMessage(R.string.dialog_message_permission_overlay)
                    setTitle(R.string.dialog_title_permission_overlay)
                    setPositiveButton(R.string.dialog_button_ok) { _, _ ->
                        activity.startActivityForResult(intent, requestCode)
                    }
                    setOnDismissListener { alertExists = false; }
                    show()
                }
            }
        }
    }

    object WriteSettings : ElevatedPermission() {
        override val requestCode: Int = REQ_CODE_SETTINGS

        override val granted: Boolean
            get() = if (atLeastAPI(23)) Settings.System.canWrite(appContext) else true
        var alertExists = false;

        override @TargetApi(23)
        fun send(activity: Activity) {

            val intent = Intent(
                Settings.ACTION_MANAGE_WRITE_SETTINGS,
                Uri.parse("package:" + activity.packageName)
            )

            if (!alertExists) {
                // Ensure only one alert will exist at a time
                alertExists = true;
                AlertDialog.Builder(activity).run {
                    setMessage(R.string.dialog_message_permission_write_settings)
                    setTitle(R.string.dialog_title_permission_write_settings)
                    setPositiveButton(R.string.dialog_button_ok) { _, _ ->
                        activity.startActivityForResult(intent, requestCode)
                    }
                    setOnDismissListener { alertExists = false; }
                    show()
                }
            }
        }
    }
}
