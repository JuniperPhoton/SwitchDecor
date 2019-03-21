//
//  LoggerDelegate.swift
//  Runner
//
//  Created by Dengweichao on 2019/3/20.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import CocoaLumberjack

class LoggerDelegate {
    init() {
        DDLog.add(DDOSLogger.sharedInstance)
    }
    
    func registerDirChannel(_ binaryMessenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(name: "logger", binaryMessenger: binaryMessenger)
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
            let method = call.method
            
            guard let tag = call.getArgument(name: "tag") else {
                return
            }
            
            guard let message = call.getArgument(name: "message") else {
                return
            }
            
            if (method == "logi") {
                DDLogInfo("\(tag): \(message)")
            } else if (method == "logv") {
                DDLogVerbose("\(tag): \(message)")
            } else if (method == "logd") {
                DDLogDebug("\(tag): \(message)")
            } else if (method == "logw") {
                DDLogWarn("\(tag): \(message)")
            } else if (method == "loge") {
                DDLogError("\(tag): \(message)")
            }
        }
    }
}
