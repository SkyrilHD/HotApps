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
            var haURL = Bundle.main.bundleURL
            for _ in 1...4 {
                haURL = haURL.deletingLastPathComponent()
            }

            if #available(macOS 10.15, *) {
                let config = NSWorkspace.OpenConfiguration()
                NSWorkspace.shared.openApplication(at: haURL, configuration: config)
            } else {
                // Fallback on earlier versions
                NSWorkspace.shared.open(haURL)
            }
        }

        NSApp.terminate(nil)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
