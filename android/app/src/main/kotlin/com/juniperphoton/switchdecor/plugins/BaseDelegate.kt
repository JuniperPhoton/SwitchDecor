package com.juniperphoton.switchdecor.plugins

import androidx.annotation.CallSuper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import android.util.Log
import io.flutter.plugin.common.MethodChannel

abstract class BaseDelegate : MethodChannel.MethodCallHandler {
    abstract val channelName: String

    fun register(messenger: BinaryMessenger) {
        MethodChannel(messenger, channelName).setMethodCallHandler(this)
    }

    @CallSuper
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.i(channelName, "Perform method call. Name is ${call.method}")
    }
}