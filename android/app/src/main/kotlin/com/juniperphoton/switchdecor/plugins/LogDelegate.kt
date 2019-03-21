package com.juniperphoton.switchdecor.plugins

import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * @author JuniperPhoton @ Zhihu Inc.
 * @since 2019-03-20
 */
class LogDelegate : BaseDelegate() {
    companion object {
        private const val NAME = "logger"
    }

    override val channelName: String
        get() = NAME

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        super.onMethodCall(call, result)

        val tag = call.argument<String>("tag")
        val message = call.argument<String>("message")

        when {
            call.method == "logi" -> {
                Log.i(tag, message)
            }
            call.method == "logd" -> {
                Log.d(tag, message)
            }
            call.method == "logv" -> {
                Log.v(tag, message)
            }
            call.method == "logw" -> {
                Log.w(tag, message)
            }
            call.method == "loge" -> {
                Log.e(tag, message)
            }
            else -> {
                Log.i(NAME, "unknown method in $NAME")
            }
        }
    }
}