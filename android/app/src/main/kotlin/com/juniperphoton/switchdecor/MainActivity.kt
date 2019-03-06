package com.juniperphoton.switchdecor

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.view.View.*
import android.view.WindowManager
import android.view.WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
import androidx.core.app.ActivityCompat
import com.juniperphoton.switchdecor.plugins.ColorPickerDelegate
import com.juniperphoton.switchdecor.plugins.DirProviderDelegate
import com.juniperphoton.switchdecor.plugins.LauncherDelegate
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity(), DirProviderDelegate.Callback {
    companion object {
        private const val TAG = "MainActivity"
        private const val REQUEST_PERMISSION_CODE = 10010
    }

    private var dirChannelDelegate = DirProviderDelegate(this)
    private var colorPickerDelegate = ColorPickerDelegate(this)
    private var launcherDelegate = LauncherDelegate(this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            val lp = window.attributes
            lp.layoutInDisplayCutoutMode = LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
            window.attributes = lp
        }

        GeneratedPluginRegistrant.registerWith(this)
        dirChannelDelegate.register(flutterView)
        colorPickerDelegate.register(flutterView)
        launcherDelegate.register(flutterView)
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
        } else {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }
}
