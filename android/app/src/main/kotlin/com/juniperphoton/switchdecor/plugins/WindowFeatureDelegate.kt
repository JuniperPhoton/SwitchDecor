package com.juniperphoton.switchdecor.plugins

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class WindowFeatureDelegate(private val callback: Callback) : BaseDelegate() {
    companion object {
        private const val NAME = "WindowFeature"
        private const val SET_NAVIGATION_BAR = "setNavigationBar"
        private const val SET_NAVIGATION_BAR_BACKGROUND_COLOR = "color"
        private const val SET_NAVIGATION_BAR_LIGHT = "isLight"
    }

    interface Callback {
        fun onRequestNavigationColorChanged(color: Int, light: Boolean)
    }

    override val channelName: String
        get() = NAME

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        super.onMethodCall(call, result)

        if (call.method == SET_NAVIGATION_BAR) {
            val color = call.argument<Long>(SET_NAVIGATION_BAR_BACKGROUND_COLOR) ?: return
            val isLight = call.argument<Boolean>(SET_NAVIGATION_BAR_LIGHT) ?: false
            callback.onRequestNavigationColorChanged(color.toInt(), isLight)
        }
    }
}