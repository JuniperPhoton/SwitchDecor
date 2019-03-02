import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "DirProvider", binaryMessenger: controller)
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
            let method = call.method

            if (method == "notifyScanFile") {
                let path = self.getParamByName(call, "path")
                if let realPath = path {
                    guard let image = UIImage(contentsOfFile: realPath) else {
                        print("Image is null, path: \(path)")
                        result(false)
                        return
                    }
                    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                    result(true)
                    return
                }
                result(false)
            }
        }

        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none)
        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func getParamByName(_ call: FlutterMethodCall, _ name: String) -> String? {
        return (call.arguments as! Dictionary<String, String>)[name];
    }
}
