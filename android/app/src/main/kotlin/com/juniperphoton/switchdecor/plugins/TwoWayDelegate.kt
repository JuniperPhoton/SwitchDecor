package com.juniperphoton.switchdecor.plugins

import androidx.annotation.CallSuper
import com.juniperphoton.switchdecor.utils.Pasteur
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * @author JuniperPhoton @ Zhihu Inc.
 * @since 2019-03-17
 */
abstract class TwoWayDelegate : BaseDelegate() {
    companion object {
        private const val TAG = "TwoWayDelegate"
        private const val REGISTER = "register"
        private const val UNREGISTER = "unregister"
    }

    var registered = false
        private set

    @CallSuper
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        super.onMethodCall(call, result)

        if (call.method == REGISTER) {
            Pasteur.info(TAG, "register")
            registered = true
            doOnRegister()
        } else if (call.method == UNREGISTER) {
            Pasteur.info(TAG, "unregister")
            registered = false
            doOnUnregister()
        }
    }

    open fun doOnRegister() = Unit

    open fun doOnUnregister() = Unit
}