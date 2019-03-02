package com.juniperphoton.switchdecor

import android.content.Intent
import android.net.Uri
import android.os.Environment
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import android.util.Log;

class DirProviderDelegate : MethodChannel.MethodCallHandler {
    interface Callback {
        fun requestPermissions()
        fun sendBroadcast(intent: Intent)
    }

    companion object {
        private const val TAG = "DirProviderDelegate"
        private const val NOTIFY_SCAN_FILE = "notifyScanFile"
        private const val GET_PICTURE_DIR = "getPictureDir"
        private const val CHANNEL_NAME = "DirProvider"
    }

    private var result: MethodChannel.Result? = null
    private var callback: Callback? = null
    private var fileName: String? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.i(TAG, call.method)

        if (call.method == GET_PICTURE_DIR) {
            fileName = call.argument("name")
            callback?.requestPermissions()
            this.result = result
        } else if (call.method == NOTIFY_SCAN_FILE) {
            val path = call.argument<String>("path")
            val intent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE)
            intent.data = Uri.fromFile(File(path))
            callback?.sendBroadcast(intent)
            result.success(true)
        }
    }

    fun register(messenger: BinaryMessenger, callback: Callback) {
        this.callback = callback
        MethodChannel(messenger, CHANNEL_NAME).setMethodCallHandler(this)
    }

    fun onPermissionGranted() {
        var dir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
        dir = File(dir, "SwitchDecor")
        if (!dir.exists() && !dir.mkdir()) {
            setResult(null)
        } else {
            setResult((File(dir, fileName).path))
        }
    }

    fun setResult(path: String?) {
        if (path.isNullOrEmpty()) {
            result?.error("Failed", null, null)
        } else {
            result?.success(path)
        }
    }
}
