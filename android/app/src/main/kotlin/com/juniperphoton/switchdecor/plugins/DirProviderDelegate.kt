package com.juniperphoton.switchdecor.plugins

import android.content.Intent
import android.net.Uri
import android.os.Environment
import com.juniperphoton.switchdecor.plugins.extensions.simpleError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class DirProviderDelegate(private val callback: Callback) : BaseDelegate() {
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
    private var fileName: String? = null

    override val channelName: String
        get() = CHANNEL_NAME

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        super.onMethodCall(call, result)

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
            result?.simpleError("Failed")
        } else {
            result?.success(path)
        }
    }
}
