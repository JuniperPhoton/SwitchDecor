package com.juniperphoton.switchdecor.plugins

import android.content.Context
import android.net.Uri
import androidx.annotation.UiThread
import com.juniperphoton.switchdecor.utils.FileUriProcessor
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*

class ShareFromNativeDelegate(private val context: Context) : BaseDelegate() {
    companion object {
        private const val NAME = "ShareFromNative"
        private const val TIMEOUT_MS = 300L
        private const val DIALOG_SHOW_TIME_MS = 600L
    }

    override val channelName: String
        get() = NAME

    private var channel: MethodChannel? = null
    private var job: Job? = null

    override fun onRegistered(channel: MethodChannel) {
        this.channel = channel
    }

    @UiThread
    fun handleUri(uri: Uri) {
        job = GlobalScope.launch(Dispatchers.IO) {
            runAtLeastTime(TIMEOUT_MS) {
                val output: String? = readPathFromUriInternal(uri) ?: return@runAtLeastTime
                channel?.invokeMethod("onNewFilePath", mapOf("path" to output))
            } or {
                async {
                    channel?.invokeMethod("toggleDialog", mapOf("show" to true))
                    delay(DIALOG_SHOW_TIME_MS)
                    channel?.invokeMethod("toggleDialog", mapOf("show" to false))
                }
            }
        }
    }

    fun cleanUp() {
        job?.cancel()
    }

    private fun readPathFromUriInternal(uri: Uri): String? {
        return FileUriProcessor.readPathFromUri(context, uri)
    }
}

private inline fun runAtLeastTime(timeoutMs: Long, block: (() -> Unit)): TimeDelayResult {
    val start = System.currentTimeMillis()
    block()
    val end = System.currentTimeMillis()
    return TimeDelayResult(end - start > timeoutMs)
}

private inline infix fun TimeDelayResult.or(block: () -> Unit) {
    if (match) {
        block()
    }
}

private inline class TimeDelayResult(val match: Boolean)