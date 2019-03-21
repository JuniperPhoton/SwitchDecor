package com.juniperphoton.switchdecor

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.view.View
import android.view.WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
import androidx.core.app.ActivityCompat
import com.juniperphoton.switchdecor.plugins.*
import com.juniperphoton.switchdecor.utils.Pasteur
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity(), DirProviderDelegate.Callback, WindowFeatureDelegate.Callback {
    companion object {
        private const val TAG = "MainActivity"
        private const val REQUEST_PERMISSION_CODE = 10010
    }

    private val dirChannelDelegate = DirProviderDelegate(this)
    private val colorPickerDelegate = ColorPickerDelegate(this)
    private val launcherDelegate = LauncherDelegate(this)
    private val shareFromNativeDelegate = ShareFromNativeDelegate(this)
    private val windowFeatureDelegate = WindowFeatureDelegate(this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            val lp = window.attributes
            lp.layoutInDisplayCutoutMode = LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
            window.attributes = lp
        }

        GeneratedPluginRegistrant.registerWith(this)

        flutterView?.let {
            dirChannelDelegate.register(it)
            colorPickerDelegate.register(it)
            launcherDelegate.register(it)
            shareFromNativeDelegate.register(it)
            windowFeatureDelegate.register(it)
            LogDelegate().register(it)
        }

        onRequestNavigationColorChanged(Color.BLACK, false)

        intent?.let {
            handleIntent(it)
        }
    }

    override fun onStop() {
        shareFromNativeDelegate.cleanUp()
        super.onStop()
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        intent?.let {
            handleIntent(it)
        }
    }

    override fun onRequestNavigationColorChanged(color: Int, light: Boolean) {
        window.navigationBarColor = color

        var flag = window.decorView.systemUiVisibility
        flag = if (light) {
            flag or View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR
        } else {
            flag and View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR.inv()
        }
        window.decorView.systemUiVisibility = flag
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

    private fun handleIntent(intent: Intent) {
        Pasteur.info(TAG, "handle intent: $intent")
        val data = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM) ?: return
        shareFromNativeDelegate.handleUri(data)
    }
}
