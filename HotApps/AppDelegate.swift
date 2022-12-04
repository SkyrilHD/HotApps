//
//  AppDelegate.swift
//  HotApps
//
//  Created by SkyrilHD on 28.11.22.
//

import Cocoa

// TODO: Save to UserDefaults
// Example apps
var blApp = "/Applications/CotEditor.app"
var brApp = "/Applications/Meta.app"
var tlApp = "/Applications/Spek.app"
var trApp = "/Applications/Hex Fiend.app"

class AppDelegate: NSObject, NSApplicationDelegate {
    let settings = Settings()

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
            if self.cornerCheck(cornerType: "bl") {
                self.appToOpen = blApp
                self.corner = true
            }
            // bottom-right corner
            else if self.cornerCheck(cornerType: "br") {
                self.appToOpen = brApp
                self.corner = true
            }
            // top-left corner
            else if self.cornerCheck(cornerType: "tl") {
                self.appToOpen = tlApp
                self.corner = true
            }
            // top-right corner
            else if self.cornerCheck(cornerType: "tr") {
                self.appToOpen = trApp
                self.corner = true
            }

            // Add 125ms delay to prevent apps from opening immediately
            // TODO: Make this configurable
            // TODO: Add option to disable delay when configured app is front app
            usleep(useconds_t(125000))

            // Check if pointer is still at corner
            if !self.cornerCheck(cornerType: "bl") && self.appToOpen == blApp {
                self.appToOpen = ""
                self.corner = false
                return
            } else if !self.cornerCheck(cornerType: "br") && self.appToOpen == brApp {
                self.appToOpen = ""
                self.corner = false
                return
            } else if !self.cornerCheck(cornerType: "tl") && self.appToOpen == tlApp {
                self.appToOpen = ""
                self.corner = false
                return
            } else if !self.cornerCheck(cornerType: "tr") && self.appToOpen == trApp {
                self.appToOpen = ""
                self.corner = false
                return
            }

            let workspace = NSWorkspace.shared
            let frontApp = workspace.frontmostApplication!
            let frontAppName = self.cleanBundleURLString(bundleURLString: frontApp.bundleURL!.absoluteString)

            // Open application if pointer is at corner
            if (self.corner && self.appToOpen != "") {
                // Check if the corner app is the front application
                // If yes, the app will hide. Otherwise the app will be opened.
                if frontAppName != self.appToOpen {
                    for runningApp in workspace.runningApplications {
                        if runningApp.activationPolicy == .regular {
                            if self.appToOpen == self.cleanBundleURLString(bundleURLString: runningApp.bundleURL!.absoluteString) {
                                runningApp.unhide()
                                break
                            }
                        }
                    }
                    self.appPath = NSURL(fileURLWithPath: self.appToOpen, isDirectory: true) as URL
                    workspace.open(self.appPath!)
                    if #available(macOS 10.15, *) {
                        workspace.openApplication(at: self.appPath!, configuration: NSWorkspace.OpenConfiguration())
                    } else {
                        // Fallback on earlier versions
                        workspace.open(self.appPath!)
                    }
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

    func cleanBundleURLString(bundleURLString: String) -> String {
        return bundleURLString.dropFirst(7).dropLast(1).replacingOccurrences(of: "%20", with: " ")
    }

    func cornerCheck(cornerType: String) -> Bool {
        switch cornerType {
        case "bl":
            return NSEvent.mouseLocation.x == 0 && NSEvent.mouseLocation.y < 1
        case "br":
            return (NSEvent.mouseLocation.x).rounded() >= NSScreen.main!.frame.maxX && NSEvent.mouseLocation.y < 1
        case "tl":
            return NSEvent.mouseLocation.x == 0 && (NSEvent.mouseLocation.y).rounded() >= NSScreen.main!.frame.maxY
        case "tr":
            return (NSEvent.mouseLocation.x).rounded() >= NSScreen.main!.frame.maxX && (NSEvent.mouseLocation.y).rounded() >= NSScreen.main!.frame.maxY
        default:
            return false
        }
    }

    @objc func aboutApp() {
        _ = AboutApp()
    }

    @objc func openSettings() {
        settings.window?.delegate = settings
        settings.showWindow(self)
    }
}

