package com.juniperphoton.switchdecor

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import androidx.palette.graphics.Palette
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ColorPickerDelegate(private val context: Context) : MethodChannel.MethodCallHandler {
    companion object {
        private const val PICK_COLOR = "pickColors"
        private const val CHANNEL_NAME = "ColorPicker"
        private const val MAX_SIDE = 1500
    }

    fun register(messenger: BinaryMessenger) {
        MethodChannel(messenger, CHANNEL_NAME).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == PICK_COLOR) {
            val uri = call.argument<String>("uri")
            val bm = decodeBitmap(Uri.parse(uri)) ?: kotlin.run {
                result.error("Failed to decode bitmap", null, null)
                return
            }
            val builder = Palette.from(bm)
            builder.generate { p ->
                if (p == null) {
                    result.error("Failed to pick colors", null, null)
                    return@generate
                }

                var list = ArrayList<Int>()
                readSwatchToList(list, p.dominantSwatch)
                readSwatchToList(list, p.lightVibrantSwatch)
                readSwatchToList(list, p.lightMutedSwatch)
                readSwatchToList(list, p.darkVibrantSwatch)
                readSwatchToList(list, p.darkMutedSwatch)
                list.distinct()

                result.success(list)
            }
        }
    }

    private fun readSwatchToList(outList: ArrayList<Int>, swatch: Palette.Swatch?) {
        swatch ?: return

        outList.add(swatch.rgb)
    }

    private fun decodeBitmap(uri: Uri): Bitmap? {
        val o = BitmapFactory.Options().apply {
            inJustDecodeBounds = true
        }
        val pfd = context.contentResolver.openFileDescriptor(uri, "r")
        pfd?.use {
            BitmapFactory.decodeFileDescriptor(it.fileDescriptor, null, o)
            val maxSide = Math.max(o.outWidth, o.outHeight)
            if (maxSide > MAX_SIDE) {
                o.inSampleSize = MAX_SIDE / maxSide
            }
            o.inJustDecodeBounds = false
            return BitmapFactory.decodeFileDescriptor(it.fileDescriptor, null, o)
        }

        return null
    }
}