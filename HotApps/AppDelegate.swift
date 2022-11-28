//
//  AppDelegate.swift
//  HotApps
//
//  Created by SkyrilHD on 28.11.22.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    @objc func aboutApp() {
        _ = AboutApp()
    }
}

