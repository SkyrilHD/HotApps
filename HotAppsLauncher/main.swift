//
//  AppDelegate.swift
//  HotAppsLauncher
//
//  Created by SkyrilHD on 07.12.22.
//  Copyright © 2022 SkyrilHD. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainBundleID = "com.skyrilhd.HotApps"

        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains {
            $0.bundleIdentifier == mainBundleID
        }

        if !isRunning {
            var path = Bundle.main.bundlePath as NSString
            for _ in 1...4 {
                path = path.deletingLastPathComponent as NSString
            }

            let mainPathString = path as String
            NSWorkspace.shared.launchApplication(mainPathString)
        }

        NSApp.terminate(nil)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
