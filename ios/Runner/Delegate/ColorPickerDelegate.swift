//
//  ColorPickerDelegate.swift
//  Runner
//
//  Created by Dengweichao on 2019/3/5.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

class ColorPickerDelegate {
    func registerColorPickerChannel(_ binaryMessenger: FlutterBinaryMessenger) {
        let colorChannel = FlutterMethodChannel(name: "ColorPicker", binaryMessenger: binaryMessenger)
        colorChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            var set = Set<Int>()

            guard let uriString = call.getArgument(name: "uri") else {
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

            image.getColors() { (colors) in
                if let primary = colors.primary?.cgColor {
                    self.addColor(&set, primary.getHexInt())
                }

                if let secondary = colors.secondary?.cgColor {
                    self.addColor(&set, secondary.getHexInt())
                }

                if let detail = colors.detail?.cgColor {
                    self.addColor(&set, detail.getHexInt())
                }

                if let background = colors.background?.cgColor {
                    self.addColor(&set, background.getHexInt())
                }

                result(Array(set))
            }
        }
    }

    private func addColor(_ set: inout Set<Int>, _ colorInt: Int) {
        if (colorInt != 0) {
            set.insert(colorInt)
        }
    }
}
