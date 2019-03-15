package com.juniperphoton.switchdecor.plugins

import androidx.annotation.CallSuper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import android.util.Log
import io.flutter.plugin.common.MethodChannel

abstract class BaseDelegate : MethodChannel.MethodCallHandler {
    abstract val channelName: String

    private lateinit var channel: MethodChannel

    fun register(messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, channelName)
        channel.setMethodCallHandler(this)
        onRegistered(channel)
    }

    open fun onRegistered(channel: MethodChannel) = Unit

    @CallSuper
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.i(channelName, "Perform method call. Name is ${call.method}")
    }
}