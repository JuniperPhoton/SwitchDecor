//
//  DirProvider.swift
//  Runner
//
//  Created by Dengweichao on 2019/3/5.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

class DirProviderDelegate {
    func registerDirChannel(_ binaryMessenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(name: "DirProvider", binaryMessenger: binaryMessenger)
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
            let method = call.method

            if (method == "notifyScanFile") {
                guard let path = call.getArgument(name: "path") else {
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
}
