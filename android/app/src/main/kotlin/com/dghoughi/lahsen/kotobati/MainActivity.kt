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
import com.dghoughi.lahsen.kotobati.FileUtils.requestPermission

class MainActivity : FlutterActivity() {

    companion object {
        const val CHANNEL_NAME = "com.kotobati.pdf_reader_channel"
        const val READ_EXTERNAL_STORAGE_PERMISSION_REQUEST_CODE = 100
    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "requestStoragePermission" -> {
                        requestStoragePermission(result)

                        //requestPermission(this@MainActivity as Context)
                    }

                    "getPdfFilesFromNative" -> {

                        val pdfFiles = getPdfFilesFromStorage()
                        result.success(pdfFiles)


                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun requestStoragePermission(result: MethodChannel.Result) {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
//            //Android is 11(R) or above
//            Environment.isExternalStorageManager()
//        } else {


        //Android is below 11(R)
//            val read =
//                ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE)
//            read == PackageManager.PERMISSION_GRANTED
        //    }

        //  if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
        //Android is 11(R) or above
//        try {
//            // Log.d(TAG, "requestPermission: try")
//            val intent = Intent()
//            intent.action = Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION
//            val uri = Uri.fromParts("package", this.packageName, null)
//            intent.data = uri
//            // storageActivityResultLauncher.launch(intent)
//            ActivityCompat.requestPermissions(
//                this,
//                arrayOf(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION),
//                READ_EXTERNAL_STORAGE_PERMISSION_REQUEST_CODE
//            )
//        } catch (e: Exception) {
//            //  Log.e(TAG, "requestPermission: ", e)
//            val intent = Intent()
//            intent.action = Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION
//            // storageActivityResultLauncher.launch(intent)
//            ActivityCompat.requestPermissions(
//                this,
//                arrayOf(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION),
//                READ_EXTERNAL_STORAGE_PERMISSION_REQUEST_CODE
//            )
//        }
        //   } else {
        //Android is below 11(R)
//            ActivityCompat.requestPermissions(
//                this,
//                arrayOf(
//                    Manifest.permission.WRITE_EXTERNAL_STORAGE,
//                    Manifest.permission.READ_EXTERNAL_STORAGE
//                ),
//                STORAGE_PERMISSION_CODE
//            )
        //       }

        if (ContextCompat.checkSelfPermission(
                this,
                android.Manifest.permission.READ_EXTERNAL_STORAGE
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

//    private val storageActivityResultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()){
//      //  Log.d(TAG, "storageActivityResultLauncher: ")
//        //here we will handle the result of our intent
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R){
//            //Android is 11(R) or above
//            if (Environment.isExternalStorageManager()){
//                //Manage External Storage Permission is granted
//              //  Log.d(TAG, "storageActivityResultLauncher: Manage External Storage Permission is granted")
//               // createFolder()
//            }
//            else{
//                //Manage External Storage Permission is denied....
//               // Log.d(TAG, "storageActivityResultLauncher: Manage External Storage Permission is denied....")
//              //  toast("Manage External Storage Permission is denied....")
//            }
//        }
//        else{
//            //Android is below 11(R)
//        }
//    }

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

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == READ_EXTERNAL_STORAGE_PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty()) {
                //check each permission if granted or not
                val write = grantResults[0] == PackageManager.PERMISSION_GRANTED
                val read = grantResults[1] == PackageManager.PERMISSION_GRANTED
                if (write && read) {
                    //External Storage Permission granted
                    //Log.d(TAG, "onRequestPermissionsResult: External Storage Permission granted")
                    // createFolder()
                    MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL_NAME)
                        .invokeMethod("requestStoragePermission", true)
                } else {
                    //External Storage Permission denied...
                    //  Log.d(TAG, "onRequestPermissionsResult: External Storage Permission denied...")
                    //  toast("External Storage Permission denied...")
                    MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL_NAME)
                        .invokeMethod("requestStoragePermission", false)
                }
            }
        }
    }

//    override fun onRequestPermissionsResult(
//        requestCode: Int,
//        permissions: Array<out String>,
//        grantResults: IntArray
//    ) {
//        if (requestCode == READ_EXTERNAL_STORAGE_PERMISSION_REQUEST_CODE) {
//            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
//                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL_NAME)
//                    .invokeMethod("requestStoragePermission", true)
//            } else {
//                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL_NAME)
//                    .invokeMethod("requestStoragePermission", false)
//            }
//        }
//        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
//    }
}

object FileUtils {

    fun requestPermission(context: Context) {
        ActivityCompat.requestPermissions(
            context as Activity,
            arrayOf(
                android.Manifest.permission.READ_EXTERNAL_STORAGE,
                android.Manifest.permission.WRITE_EXTERNAL_STORAGE,
                android.Manifest.permission.ACCESS_MEDIA_LOCATION
            ),
            101
        ); }

}
