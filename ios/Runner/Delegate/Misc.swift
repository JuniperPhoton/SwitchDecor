//
//  Misc.swift
//  Runner
//
//  Created by Dengweichao on 2019/3/5.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

extension FlutterMethodCall {
    func getArgument(name: String!) -> String? {
        return (arguments as! Dictionary<String, String>)[name];
    }
}

extension CGColor {
    func getHexInt() -> Int {
        let r = lroundf(Float(components![0]) * 255)
        let g = lroundf(Float(components![1]) * 255)
        let b = lroundf(Float(components![2]) * 255)

        let a: Int
        if (numberOfComponents == 4) {
            a = lroundf(Float(components![3]) * 255)
        } else {
            a = 255
        }

        let c = a << 24 | r << 16 | g << 8 | b
        return c
    }
}
