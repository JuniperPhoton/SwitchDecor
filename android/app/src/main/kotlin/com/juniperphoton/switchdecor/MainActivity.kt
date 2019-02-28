package com.juniperphoton.switchdecor

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import androidx.core.app.ActivityCompat
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File

class MainActivity : FlutterActivity() {
    companion object {
        private const val TAG = "MainActivity"
        private const val REQUEST_PERMISSION_CODE = 0
        private const val GET_PICTURE_DIR_CHANNEL = "DirProvider"
        private const val NOTIFY_SCAN_FILE = "notifyScanFile"
        private const val GET_PICTURE_DIR = "getPictureDir"
    }

    private var result: MethodChannel.Result? = null
    private var fileName: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, GET_PICTURE_DIR_CHANNEL)
                .setMethodCallHandler { call, result ->
                    if (this.result != null) {
                        Log.i(TAG, "waiting for result")
                        return@setMethodCallHandler
                    }

                    Log.i(TAG, call.method)

                    if (call.method == GET_PICTURE_DIR) {
                        fileName = call.argument("name")
                        requestPermissions()
                        this.result = result
                    } else if (call.method == NOTIFY_SCAN_FILE) {
                        val path = call.argument<String>("path")
                        val intent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE)
                        intent.data = Uri.fromFile(File(path))
                        sendBroadcast(intent)
                        result.success(true)
                    }
                }
    }

    private fun requestPermissions() {
        ActivityCompat.requestPermissions(this,
                arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), REQUEST_PERMISSION_CODE)
    }

    override fun onRequestPermissionsResult(requestCode: Int,
                                            permissions: Array<out String>, grantResults: IntArray) {
        if (requestCode == REQUEST_PERMISSION_CODE) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                var dir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
                dir = File(dir, "SwitchDecor")
                if (!dir.exists() && !dir.mkdir()) {
                    result?.error("Failed to mkdir", null, null)
                } else {
                    result?.success(File(dir, fileName).path)
                }
            } else {
                result?.error("Failed to get permission", null, null)
            }
            result = null
        }
    }
}
