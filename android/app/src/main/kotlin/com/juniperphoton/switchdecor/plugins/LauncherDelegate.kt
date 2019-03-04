package com.juniperphoton.switchdecor.plugins

import android.content.Context
import android.content.Intent
import androidx.core.content.FileProvider
import com.juniperphoton.switchdecor.plugins.extensions.simpleError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class LauncherDelegate(private val context: Context) : BaseDelegate() {
    companion object {
        private const val CHANNEL_NAME = "Launcher"
    }

    override val channelName: String
        get() = CHANNEL_NAME

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        super.onMethodCall(call, result)

        if (call.method == "launchFile") {
            val path = call.argument<String>("path") ?: kotlin.run {
                result.simpleError("Failed to get uri")
                return
            }

            try {
                val uri = FileProvider.getUriForFile(context, context.packageName, File(path))
                val intent = Intent().apply {
                    action = Intent.ACTION_VIEW
                    data = uri
                    setDataAndType(uri, "image/*")
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                }
                context.startActivity(intent)
                result.success(true)
            } catch (e: Exception) {
                result.simpleError("Failed to launch: ${e.message}")
            }
        }
    }
}