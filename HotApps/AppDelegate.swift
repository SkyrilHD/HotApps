//
//  AppDelegate.swift
//  HotApps
//
//  Created by SkyrilHD on 28.11.22.
//

import Cocoa

// TODO: Save to UserDefaults
// Example apps
let blApp = "CotEditor.app"
let brApp = "Meta.app"
let tlApp = "Spek.app"
let trApp = "Hex Fiend.app"

class AppDelegate: NSObject, NSApplicationDelegate {

    

    var corner: Bool = false
    var appPath: URL?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) {_ in
            #if DEBUG
                //print(NSEvent.mouseLocation)
            #endif

            // This will check if the pointer is moved to any corner
            // bottom-left corner
            if NSEvent.mouseLocation.x == 0 && NSEvent.mouseLocation.y < 1 {
                self.appPath = NSURL(fileURLWithPath: "/Applications/"+blApp, isDirectory: true) as URL
                self.corner = true
            }
            // bottom-right corner
            else if (NSEvent.mouseLocation.x).rounded() >= NSScreen.main!.frame.maxX && NSEvent.mouseLocation.y < 1 {
                self.appPath = NSURL(fileURLWithPath: "/Applications/"+brApp, isDirectory: true) as URL
                self.corner = true
            }
            // top-left corner
            else if NSEvent.mouseLocation.x == 0 && (NSEvent.mouseLocation.y).rounded() >= NSScreen.main!.frame.maxY {
                self.appPath = NSURL(fileURLWithPath: "/Applications/"+tlApp, isDirectory: true) as URL
                self.corner = true
            }
            // top-right corner
            else if (NSEvent.mouseLocation.x).rounded() >= NSScreen.main!.frame.maxX && (NSEvent.mouseLocation.y).rounded() >= NSScreen.main!.frame.maxY {
                self.appPath = NSURL(fileURLWithPath: "/Applications/"+trApp, isDirectory: true) as URL
                self.corner = true
            }

            // Open application if pointer is at corner
            if (self.corner) {
                let path = "/bin"
                let configuration = NSWorkspace.OpenConfiguration()
                configuration.arguments = [path]
                NSWorkspace.shared.openApplication(at: self.appPath!,
                                                   configuration: configuration,
                                                   completionHandler: nil)
                self.corner = false
            }
        }
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

