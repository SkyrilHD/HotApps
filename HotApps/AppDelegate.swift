//
//  AppDelegate.swift
//  HotApps
//
//  Created by SkyrilHD on 28.11.22.
//

import Cocoa

// TODO: Save to UserDefaults
// Example apps
let blApp = "/Applications/CotEditor.app"
let brApp = "/Applications/Meta.app"
let tlApp = "/Applications/Spek.app"
let trApp = "/Applications/Hex Fiend.app"

class AppDelegate: NSObject, NSApplicationDelegate {

    
    var appToOpen: String = ""
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
                self.appToOpen = blApp
                self.corner = true
            }
            // bottom-right corner
            else if (NSEvent.mouseLocation.x).rounded() >= NSScreen.main!.frame.maxX && NSEvent.mouseLocation.y < 1 {
                self.appToOpen = brApp
                self.corner = true
            }
            // top-left corner
            else if NSEvent.mouseLocation.x == 0 && (NSEvent.mouseLocation.y).rounded() >= NSScreen.main!.frame.maxY {
                self.appToOpen = tlApp
                self.corner = true
            }
            // top-right corner
            else if (NSEvent.mouseLocation.x).rounded() >= NSScreen.main!.frame.maxX && (NSEvent.mouseLocation.y).rounded() >= NSScreen.main!.frame.maxY {
                self.appToOpen = trApp
                self.corner = true
            }

            let frontApp = NSWorkspace.shared.frontmostApplication!
            let frontAppName = frontApp.bundleURL!.absoluteString.dropFirst(7).dropLast(1).replacingOccurrences(of: "%20", with: " ")

            // Open application if pointer is at corner
            if (self.corner && self.appToOpen != "") {
                // Check if the corner app is the front application
                // If yes, the app will hide. Otherwise the app will be opened.
                if frontAppName != self.appToOpen {
                    for runningApp in NSWorkspace.shared.runningApplications {
                        if runningApp.activationPolicy == .regular {
                            if self.appToOpen == runningApp.bundleURL!.absoluteString.dropFirst(7).dropLast(1).replacingOccurrences(of: "%20", with: " ") {
                                runningApp.unhide()
                                break
                            }
                        }
                    }
                    self.appPath = NSURL(fileURLWithPath: self.appToOpen, isDirectory: true) as URL
                    NSWorkspace.shared.open(self.appPath!)
                    sleep(1)

                } else {
                    frontApp.hide()
                    sleep(1)
                }

                self.corner = false
                self.appToOpen = ""
            }
        }

        // Create status bar
        _ = StatusBar()
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

