//
//  AppDelegate.swift
//  HotApps
//
//  Created by SkyrilHD on 28.11.22.
//  Copyright © 2022 SkyrilHD. All rights reserved.
//

import Cocoa
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    var appSettings = AppSettings.shared
    var settings: Settings?
    var aboutApp: AboutApp?

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
        if cornerCheck(cornerType: "bl") && appSettings.blEnabled {
            appToOpen = appSettings.blApp
            corner = true
            return "bl"
        }
        // bottom-right corner
        else if cornerCheck(cornerType: "br") && appSettings.brEnabled {
            appToOpen = appSettings.brApp
            corner = true
            return "br"
        }
        // top-left corner
        else if cornerCheck(cornerType: "tl") && appSettings.tlEnabled {
            appToOpen = appSettings.tlApp
            corner = true
            return "tl"
        }
        // top-right corner
        else if cornerCheck(cornerType: "tr") && appSettings.trEnabled {
            appToOpen = appSettings.trApp
            corner = true
            return "tr"
        }

        return nil
    }

    func stillAtCorner(cornerType: String?) -> Bool {
        // Check if pointer is still at corner
        switch cornerType {
        case "bl":
            if !cornerCheck(cornerType: "bl") && appToOpen == appSettings.blApp {
                appToOpen = ""
                corner = false
                return false
            }
        case "br":
            if !cornerCheck(cornerType: "br") && appToOpen == appSettings.brApp {
                appToOpen = ""
                corner = false
                return false
            }
        case "tl":
            if !cornerCheck(cornerType: "tl") && appToOpen == appSettings.tlApp {
                appToOpen = ""
                corner = false
                return false
            }
        case "tr":
            if !cornerCheck(cornerType: "tr") && appToOpen == appSettings.trApp {
                appToOpen = ""
                corner = false
                return false
            }
        default:
            appToOpen = ""
            corner = false
            return false
        }

        return true
    }

    func openApplication(workspace: NSWorkspace, frontApp: NSRunningApplication,
                         frontAppName: String, cornerType: String?) {
        // Open application if pointer is at corner
        if corner && appToOpen != "" {
            if lastCorner == corner {
                return
            }
            // Check if the corner app is the front application
            // If yes, the app will hide. Otherwise the app will be opened.
            if frontAppName != appToOpen {
                for runningApp in workspace.runningApplications where runningApp.activationPolicy == .regular {
                    if appToOpen == runningApp.bundleURL!.cleanBundleURL {
                        runningApp.unhide()
                        break
                    }
                }
                appPath = NSURL(fileURLWithPath: appToOpen, isDirectory: true) as URL
                if #available(macOS 10.15, *) {
                    workspace.openApplication(at: appPath!, configuration: NSWorkspace.OpenConfiguration())
                } else {
                    // Fallback on earlier versions
                    workspace.open(appPath!)
                }
            } else {
                if appSettings.delayHide {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(appSettings.msDelay)/1000) {
                        if self.stillAtCorner(cornerType: cornerType) {
                            frontApp.hide()
                        }
                    }
                } else {
                    frontApp.hide()
                }
            }

            lastCorner = corner
            corner = false
            appToOpen = ""
        }
    }

    func mainEvent() {
        let cornerType = pointerCheck()

        let workspace = NSWorkspace.shared

        // If the user is not logged in, there is no frontmost app
        // This happens if the user is in screen saver or login screen
        guard let frontApp = workspace.frontmostApplication else { return }

        guard let bundleURL = frontApp.bundleURL else { return }

        let frontAppName = bundleURL.cleanBundleURL

        // Add 125ms delay (by default) to prevent apps from opening immediately
        if (frontAppName != appToOpen) && corner == true && appToOpen != "" {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(appSettings.msDelay)/1000) {
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
                lastCorner = corner
                return
            }

            openApplication(workspace: workspace, frontApp: frontApp,
                            frontAppName: frontAppName, cornerType: cornerType)
        }
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
        guard let screen = pointerAtScreen() else {
            // There is no display, so do nothing
            return false
        }

        switch cornerType {
        case "bl":
            return NSEvent.mouseLocation.x < screen.frame.minX+1 && NSEvent.mouseLocation.y < screen.frame.minY+1
        case "br":
            return (NSEvent.mouseLocation.x).rounded() >= screen.frame.maxX
            && NSEvent.mouseLocation.y < screen.frame.minY+1
        case "tl":
            return NSEvent.mouseLocation.x < screen.frame.minX+1
            && (NSEvent.mouseLocation.y).rounded() >= screen.frame.maxY
        case "tr":
            return (NSEvent.mouseLocation.x).rounded() >= screen.frame.maxX
                && (NSEvent.mouseLocation.y).rounded() >= screen.frame.maxY
        default:
            return false
        }
    }

    func startupCheck() {
        let launcherBundleID = "com.skyrilhd.HotAppsLauncher"
        SMLoginItemSetEnabled(launcherBundleID as CFString, appSettings.startup)
    }

    @objc func openAboutApp() {
        if aboutApp == nil {
            aboutApp = AboutApp()
            aboutApp?.window?.delegate = aboutApp
        }

        aboutApp?.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc func openSettings() {
        if settings == nil {
            settings = Settings()
            settings?.window?.delegate = settings
        }

        settings?.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
    }
}

extension URL {
    var cleanBundleURL: String {
        var selPath = self.path

        if selPath.hasSuffix("/") {
            selPath = String(selPath.dropLast())
        }
        return selPath
    }
}
