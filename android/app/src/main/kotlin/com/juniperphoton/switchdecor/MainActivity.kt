package com.juniperphoton.switchdecor

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import androidx.core.app.ActivityCompat
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity(), DirProviderDelegate.Callback {
    companion object {
        private const val TAG = "MainActivity"
        private const val REQUEST_PERMISSION_CODE = 0
    }

    private var dirChannelDelegate = DirProviderDelegate()
    private var colorPickerDelegate = ColorPickerDelegate(this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        dirChannelDelegate.register(flutterView, this)
        colorPickerDelegate.register(flutterView)
    }

    override fun requestPermissions() {
        ActivityCompat.requestPermissions(this,
                arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), REQUEST_PERMISSION_CODE)
    }

    override fun onRequestPermissionsResult(requestCode: Int,
                                            permissions: Array<out String>, grantResults: IntArray) {
        if (requestCode == REQUEST_PERMISSION_CODE) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                dirChannelDelegate.onPermissionGranted()
            } else {
                dirChannelDelegate.setResult(null)
            }
        }
    }
}
