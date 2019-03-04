package com.juniperphoton.switchdecor.plugins.extensions

import io.flutter.plugin.common.MethodChannel

fun MethodChannel.Result.simpleError(msg: String) {
    this.error(msg, null, null)
}