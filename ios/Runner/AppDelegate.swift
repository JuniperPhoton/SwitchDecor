import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "DirProvider", binaryMessenger: controller)
    channel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
        if (call.method == "notifyScanFile") {
            let path = (call.arguments as! Dictionary<String,String>)["path"]
            if let realPath = path {
                guard let image = UIImage(contentsOfFile: realPath) else {
                    result(false)
                    return
                }
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                result(true)
                return;
            }
            result(false)
        }
    }
    
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
