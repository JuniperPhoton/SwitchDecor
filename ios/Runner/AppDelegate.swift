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
        registerColorPickerChannel(controller)
        registerDirChannel(controller)
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none)
        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func registerColorPickerChannel(_ binaryMessenger: FlutterBinaryMessenger) {
        let colorChannel = FlutterMethodChannel(name: "ColorPicker", binaryMessenger: binaryMessenger)
        colorChannel.setMethodCallHandler { (call, result) in
            var set = Set<Int>()

            guard let uriString = self.getParamByName(call, "uri") else {
                result(set)
                return
            }

            guard let path = URL.init(string: uriString)?.path else {
                result(set)
                return
            }

            guard let image = UIImage(contentsOfFile: path) else {
                result(set)
                return
            }

            let colors = image.getColors()

            if let primary = colors.primary?.cgColor {
                self.addColor(&set, self.getHexIntFromCIColor(primary))
            }

            if let secondary = colors.secondary?.cgColor {
                self.addColor(&set, self.getHexIntFromCIColor(secondary))
            }

            if let detail = colors.detail?.cgColor {
                self.addColor(&set, self.getHexIntFromCIColor(detail))
            }

            if let background = colors.background?.cgColor {
                self.addColor(&set, self.getHexIntFromCIColor(background))
            }

            result(Array(set))
        }
    }

    private func addColor(_ set: inout Set<Int>, _ colorInt: Int) {
        if (colorInt != 0) {
            set.insert(colorInt)
        }
    }

    private func registerDirChannel(_ binaryMessenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(name: "DirProvider", binaryMessenger: binaryMessenger)
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
            let method = call.method

            if (method == "notifyScanFile") {
                guard let path = self.getParamByName(call, "path") else {
                    result(false)
                    return
                }

                guard let image = UIImage(contentsOfFile: path) else {
                    result(false)
                    return
                }

                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                result(true)
            }
        }
    }

    private func getHexIntFromCIColor(_ color: CGColor) -> Int {
        let r = lroundf(Float(color.components![0]) * 255)
        let g = lroundf(Float(color.components![1]) * 255)
        let b = lroundf(Float(color.components![2]) * 255)

        let a: Int
        if (color.numberOfComponents == 4) {
            a = lroundf(Float(color.components![3]) * 255)
        } else {
            a = 255
        }

        let c = a << 24 | r << 16 | g << 8 | b
        return c
    }

    private func getParamByName(_ call: FlutterMethodCall, _ name: String) -> String? {
        return (call.arguments as! Dictionary<String, String>)[name];
    }
}
