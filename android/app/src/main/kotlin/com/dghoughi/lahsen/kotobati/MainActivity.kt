package com.dghoughi.lahsen.kotobati

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Environment
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import android.provider.Settings
import androidx.activity.result.contract.ActivityResultContracts


class MainActivity : FlutterActivity() {

    companion object {
        const val CHANNEL_NAME = "com.kotobati.pdf_reader_channel"
        const val READ_EXTERNAL_STORAGE_PERMISSION_REQUEST_CODE = 100
        const val MANAGE_EXTERNAL_STORAGE_PERMISSION_REQUEST_CODE = 1001
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_NAME
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestStoragePermission" -> {
                    requestStoragePermission(result)
                }

                "hasManageExternalStoragePermission" -> {
                    val isManageExternalStorageGranted = hasManageExternalStoragePermission()
                    result.success(isManageExternalStorageGranted)
                }

                "requestManageExternalStoragePermission" -> {
                    requestManageExternalStoragePermission()
                }

                "getPdfFilesFromNative" -> {
                    val pdfFiles: List<String> = getPdfFilesFromStorage()
                    result.success(pdfFiles)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun requestStoragePermission(result: MethodChannel.Result) {

        if (ContextCompat.checkSelfPermission(
                this, android.Manifest.permission.READ_EXTERNAL_STORAGE
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(android.Manifest.permission.READ_EXTERNAL_STORAGE),
                READ_EXTERNAL_STORAGE_PERMISSION_REQUEST_CODE
            )
            // The result will be handled in onRequestPermissionsResult
        } else {
            result.success(true) // Permission already granted
        }
    }

    private fun getPdfFilesFromStorage(): List<String> {
        val pdfFilesList = mutableListOf<String>()
        val rootDirectory = Environment.getExternalStorageDirectory()
        getPdfFilesRecursive(rootDirectory, pdfFilesList)
        return pdfFilesList
    }

    private fun getPdfFilesRecursive(directory: File, pdfFilesList: MutableList<String>) {
        val files = directory.listFiles() ?: return
        for (file in files) {
            if (file.isDirectory) {
                getPdfFilesRecursive(file, pdfFilesList)
            } else if (file.isFile && file.extension.equals("pdf", true)) {
                pdfFilesList.add(file.absolutePath)
            }
        }
    }

    /** Function to check if the app has the "MANAGE_EXTERNAL_STORAGE" permission **/
    private fun hasManageExternalStoragePermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            Environment.isExternalStorageManager()
        } else {
            // On devices running Android 10 and below, this permission is not needed.
            true
        }
    }

    /** Request the "MANAGE_EXTERNAL_STORAGE" permission if not granted already **/
    private fun requestManageExternalStoragePermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            if (!hasManageExternalStoragePermission()) {
                val intent = Intent(Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION)
                startActivityForResult(intent, MANAGE_EXTERNAL_STORAGE_PERMISSION_REQUEST_CODE)
            }
        }
    }

    /** Handle the result of the permission request **/
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == MANAGE_EXTERNAL_STORAGE_PERMISSION_REQUEST_CODE) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                if (hasManageExternalStoragePermission()) {
                    // The permission is granted. You can now access files on external storage.
                    MethodChannel(
                        flutterEngine!!.dartExecutor.binaryMessenger,
                        CHANNEL_NAME
                    ).invokeMethod("requestManageExternalStoragePermission", true)
                } else {
                    // The permission is denied.
                    // Handle this situation gracefully, as the user might deny the permission.
                    MethodChannel(
                        flutterEngine!!.dartExecutor.binaryMessenger,
                        CHANNEL_NAME
                    ).invokeMethod("requestManageExternalStoragePermission", false)
                }
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == READ_EXTERNAL_STORAGE_PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty()) {
                /// Check each permission if granted or not
                val read = grantResults[0] == PackageManager.PERMISSION_GRANTED

                if (read) {
                    // External Storage Permission granted
                    // Log.d(TAG, "onRequestPermissionsResult: External Storage Permission granted")
                    // createFolder()
                    MethodChannel(
                        flutterEngine!!.dartExecutor.binaryMessenger,
                        CHANNEL_NAME
                    ).invokeMethod("requestStoragePermission", true)
                } else {
                    //External Storage Permission denied...
                    //  Log.d(TAG, "onRequestPermissionsResult: External Storage Permission denied...")
                    //  toast("External Storage Permission denied...")
                    MethodChannel(
                        flutterEngine!!.dartExecutor.binaryMessenger,
                        CHANNEL_NAME
                    ).invokeMethod("requestStoragePermission", false)
                }
            }
        }
    }
}
