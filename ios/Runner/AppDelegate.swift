import UIKit
import Flutter
import UIImageColors

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        ColorPickerDelegate().registerColorPickerChannel(controller)
        DirProviderDelegate().registerDirChannel(controller)
        
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none)
        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
