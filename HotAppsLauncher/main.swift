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

        // Check if HotApps is running
        let isRunning = !NSWorkspace.shared.runningApplications.filter { $0.bundleIdentifier == mainBundleID }.isEmpty

        if !isRunning {
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(self.terminate),
                                                                name: Notification.Name("killLauncher"),
                                                                object: mainBundleID)

            // Get HotApps path
            let launcherPath = Bundle.main.bundlePath as NSString
            var launcherPathArr = launcherPath.pathComponents
            launcherPathArr.removeLast()
            launcherPathArr.removeLast()
            launcherPathArr.removeLast()
            launcherPathArr.removeLast()
            let mainPath = NSString.path(withComponents: launcherPathArr)
            let mainURL = URL(fileURLWithPath: mainPath)

            if #available(macOS 10.15, *) {
                NSWorkspace.shared.openApplication(at: mainURL, configuration: NSWorkspace.OpenConfiguration())
            } else {
                // Fallback on earlier versions
                NSWorkspace.shared.open(mainURL)
            }
        } else {
            self.terminate()
        }
    }

    @objc func terminate() {
        NSApp.terminate(nil)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

NSApplication.shared.run()
