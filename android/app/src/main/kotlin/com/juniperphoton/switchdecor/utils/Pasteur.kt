package com.juniperphoton.switchdecor.utils

import android.util.Log

/**
 * @author JuniperPhoton @ Zhihu Inc.
 * @since 2019-03-17
 */
@Suppress("ConstantConditionIf")
object Pasteur {
    private const val DEBUG = true

    fun info(tag: String, msg: String?) {
        if (!DEBUG) return
        Log.i(tag, msg)
    }

    fun warn(tag: String, msg: String?) {
        if (!DEBUG) return
        Log.w(tag, msg)
    }

    fun error(tag: String, msg: String?) {
        if (!DEBUG) return
        Log.e(tag, msg)
    }
}