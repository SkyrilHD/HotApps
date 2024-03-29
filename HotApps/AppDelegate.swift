//
//  AppDelegate.swift
//  HotApps
//
//  Created by SkyrilHD on 28.11.22.
//  Copyright © 2022 SkyrilHD. All rights reserved.
//

import Cocoa
import ServiceManagement

// currently set apps
var blApp: String = ""
var brApp: String = ""
var tlApp: String = ""
var trApp: String = ""
var blEnabled: Bool = false
var brEnabled: Bool = false
var tlEnabled: Bool = false
var trEnabled: Bool = false
var msDelay: Int = 125
var delayHide: Bool = true
var hideStatusBar: Bool = false
var startup: Bool = false

class AppDelegate: NSObject, NSApplicationDelegate {
    var settings: Settings

    override init() {
        settings = Settings()
        super.init()
        self.firstStartupCheck()
    }
    var appToOpen: String = ""
    var corner: Bool = false
    var appPath: URL?
    var lastCorner: Bool = false

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        openSettings()
        return true
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        startupCheck()

        NSEvent.addLocalMonitorForEvents(matching: .mouseMoved) {_ in
            self.mainEvent()
            return nil
        }
        NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) {_ in
            self.mainEvent()
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

    func pointerCheck() -> String? {
        // This will check if the pointer is moved to any corner
        // bottom-left corner
        if self.cornerCheck(cornerType: "bl") && blEnabled {
            self.appToOpen = blApp
            self.corner = true
            return "bl"
        }
        // bottom-right corner
        else if self.cornerCheck(cornerType: "br") && brEnabled {
            self.appToOpen = brApp
            self.corner = true
            return "br"
        }
        // top-left corner
        else if self.cornerCheck(cornerType: "tl") && tlEnabled {
            self.appToOpen = tlApp
            self.corner = true
            return "tl"
        }
        // top-right corner
        else if self.cornerCheck(cornerType: "tr") && trEnabled {
            self.appToOpen = trApp
            self.corner = true
            return "tr"
        }

        return nil
    }

    func stillAtCorner(cornerType: String?) -> Bool {
        // Check if pointer is still at corner
        switch cornerType {
        case "bl":
            if !self.cornerCheck(cornerType: "bl") && self.appToOpen == blApp {
                self.appToOpen = ""
                self.corner = false
                return false
            }
        case "br":
            if !self.cornerCheck(cornerType: "br") && self.appToOpen == brApp {
                self.appToOpen = ""
                self.corner = false
                return false
            }
        case "tl":
            if !self.cornerCheck(cornerType: "tl") && self.appToOpen == tlApp {
                self.appToOpen = ""
                self.corner = false
                return false
            }
        case "tr":
            if !self.cornerCheck(cornerType: "tr") && self.appToOpen == trApp {
                self.appToOpen = ""
                self.corner = false
                return false
            }
        default:
            self.appToOpen = ""
            self.corner = false
            return false
        }

        return true
    }

    func openApplication(workspace: NSWorkspace, frontApp: NSRunningApplication,
                         frontAppName: String, cornerType: String?) {
        // Open application if pointer is at corner
        if self.corner && self.appToOpen != "" {
            if lastCorner == corner {
                return
            }
            // Check if the corner app is the front application
            // If yes, the app will hide. Otherwise the app will be opened.
            if frontAppName != self.appToOpen {
                for runningApp in workspace.runningApplications where runningApp.activationPolicy == .regular {
                    if self.appToOpen == self.cleanBundleURLString(bundleURLString:
                                                                    runningApp.bundleURL!.absoluteString) {
                        runningApp.unhide()
                        break
                    }
                }
                self.appPath = NSURL(fileURLWithPath: self.appToOpen, isDirectory: true) as URL
                if #available(macOS 10.15, *) {
                    workspace.openApplication(at: self.appPath!, configuration: NSWorkspace.OpenConfiguration())
                } else {
                    // Fallback on earlier versions
                    workspace.open(self.appPath!)
                }
            } else {
                if delayHide {
                    print(msDelay)
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(msDelay)/1000) {
                        if self.stillAtCorner(cornerType: cornerType) {
                            frontApp.hide()
                        }
                    }
                } else {
                    frontApp.hide()
                }
            }

            self.lastCorner = self.corner
            self.corner = false
            self.appToOpen = ""
        }
    }

    func mainEvent() {
        let cornerType = pointerCheck()

        let workspace = NSWorkspace.shared

        // If the user is not logged in, there is no frontmost app
        // This happens if the user is in screen saver or login screen
        if workspace.frontmostApplication == nil {
            return
        }

        let frontApp = workspace.frontmostApplication!
        let frontAppName = self.cleanBundleURLString(bundleURLString: frontApp.bundleURL!.absoluteString)

        // Add 125ms delay (by default) to prevent apps from opening immediately
        if (frontAppName != self.appToOpen) && self.corner == true && self.appToOpen != "" {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(msDelay)/1000) {
                if !self.stillAtCorner(cornerType: cornerType) {
                    self.lastCorner = self.corner
                    return
                }
                self.openApplication(workspace: workspace, frontApp: frontApp,
                                     frontAppName: frontAppName, cornerType: cornerType)
            }
            return
        } else {
            if !stillAtCorner(cornerType: cornerType) {
                self.lastCorner = self.corner
                return
            }

            openApplication(workspace: workspace, frontApp: frontApp,
                            frontAppName: frontAppName, cornerType: cornerType)
        }
    }

    func cleanBundleURLString(bundleURLString: String) -> String {
        return bundleURLString.dropFirst(7).dropLast(1).replacingOccurrences(of: "%20", with: " ")
    }

    func pointerAtScreen() -> NSScreen? {
        // Check which screen the pointer is on
        var pointerPos: NSScreen?
        for screen in NSScreen.screens {
            if NSEvent.mouseLocation.x > screen.frame.maxX {
                continue
            } else if NSEvent.mouseLocation.y > screen.frame.maxY {
                continue
            } else if NSEvent.mouseLocation.x < screen.frame.minX {
                continue
            } else if NSEvent.mouseLocation.y < screen.frame.minY {
                continue
            }
            pointerPos = screen
        }
        return pointerPos
    }

    func cornerCheck(cornerType: String) -> Bool {
        let screen = pointerAtScreen()

        if screen == nil {
            // There is no display, so do nothing
            return false
        }

        switch cornerType {
        case "bl":
            return NSEvent.mouseLocation.x < screen!.frame.minX+1 && NSEvent.mouseLocation.y < screen!.frame.minY+1
        case "br":
            return (NSEvent.mouseLocation.x).rounded() >= screen!.frame.maxX
            && NSEvent.mouseLocation.y < screen!.frame.minY+1
        case "tl":
            return NSEvent.mouseLocation.x < screen!.frame.minX+1
            && (NSEvent.mouseLocation.y).rounded() >= screen!.frame.maxY
        case "tr":
            return (NSEvent.mouseLocation.x).rounded() >= screen!.frame.maxX
                && (NSEvent.mouseLocation.y).rounded() >= screen!.frame.maxY
        default:
            return false
        }
    }

    func firstStartupCheck() {
        // get saved app paths
        let savedBlApp = UserDefaults.standard.object(forKey: "blApp") as? String?
        let savedBrApp = UserDefaults.standard.object(forKey: "brApp") as? String?
        let savedTlApp = UserDefaults.standard.object(forKey: "tlApp") as? String?
        let savedTrApp = UserDefaults.standard.object(forKey: "trApp") as? String?

        blApp = savedBlApp! != nil ? savedBlApp!! : ""
        brApp = savedBrApp! != nil ? savedBrApp!! : ""
        tlApp = savedTlApp! != nil ? savedTlApp!! : ""
        trApp = savedTrApp! != nil ? savedTrApp!! : ""

        // check if corner detection should be enabled
        let savedBlSetting = UserDefaults.standard.object(forKey: "blEnabled") as? Bool
        let savedBrSetting = UserDefaults.standard.object(forKey: "brEnabled") as? Bool
        let savedTlSetting = UserDefaults.standard.object(forKey: "tlEnabled") as? Bool
        let savedTrSetting = UserDefaults.standard.object(forKey: "trEnabled") as? Bool

        blEnabled = savedBlSetting != nil ? savedBlSetting! : false
        brEnabled = savedBrSetting != nil ? savedBrSetting! : false
        tlEnabled = savedTlSetting != nil ? savedTlSetting! : false
        trEnabled = savedTrSetting != nil ? savedTrSetting! : false

        let msDelaySetting = UserDefaults.standard.object(forKey: "msDelay") as? Int
        msDelay = msDelaySetting != nil ? msDelaySetting! : 125

        let delayHideSetting = UserDefaults.standard.object(forKey: "delayHide") as? Bool
        delayHide = delayHideSetting != nil ? delayHideSetting! : true

        let hideStatusBarSetting = UserDefaults.standard.object(forKey: "hideStatusBar") as? Bool
        hideStatusBar = hideStatusBarSetting != nil ? hideStatusBarSetting! : false

        let startupSetting = UserDefaults.standard.object(forKey: "startup") as? Bool
        startup = startupSetting != nil ? startupSetting! : false
    }

    func startupCheck() {
        let launcherBundleID = "com.skyrilhd.HotAppsLauncher"
        SMLoginItemSetEnabled(launcherBundleID as CFString, startup)
    }

    @objc func aboutApp() {
        _ = AboutApp()
    }

    @objc func openSettings() {
        settings = Settings()
        settings.window?.delegate = settings
        settings.showWindow(self)
    }
}
