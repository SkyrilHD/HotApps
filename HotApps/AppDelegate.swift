//
//  AppDelegate.swift
//  HotApps
//
//  Created by SkyrilHD on 28.11.22.
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

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        openSettings()
        return true
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        startupCheck()

        NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) {_ in
            #if DEBUG
                //print(NSEvent.mouseLocation)
            #endif

            var cornerType = ""
            // This will check if the pointer is moved to any corner
            // bottom-left corner
            if self.cornerCheck(cornerType: "bl") && blEnabled {
                self.appToOpen = blApp
                cornerType = "bl"
                self.corner = true
            }
            // bottom-right corner
            else if self.cornerCheck(cornerType: "br") && brEnabled {
                self.appToOpen = brApp
                cornerType = "br"
                self.corner = true
            }
            // top-left corner
            else if self.cornerCheck(cornerType: "tl") && tlEnabled {
                self.appToOpen = tlApp
                cornerType = "br"
                self.corner = true
            }
            // top-right corner
            else if self.cornerCheck(cornerType: "tr") && trEnabled {
                self.appToOpen = trApp
                cornerType = "br"
                self.corner = true
            }

            let workspace = NSWorkspace.shared
            let frontApp = workspace.frontmostApplication!
            let frontAppName = self.cleanBundleURLString(bundleURLString: frontApp.bundleURL!.absoluteString)

            // Add 125ms delay (by default) to prevent apps from opening immediately
            if !delayHide && (frontAppName == self.appToOpen) {
            } else {
                if self.corner == true && self.appToOpen != "" {
                    usleep(UInt32(msDelay) * 1000)
                }
            }

            // Check if pointer is still at corner
            switch cornerType {
            case "bl":
                if !self.cornerCheck(cornerType: "bl") && self.appToOpen == blApp {
                    self.appToOpen = ""
                    self.corner = false
                    return
                }
            case "br":
                if !self.cornerCheck(cornerType: "br") && self.appToOpen == brApp {
                    self.appToOpen = ""
                    self.corner = false
                    return
                }
            case "tl":
                if !self.cornerCheck(cornerType: "tl") && self.appToOpen == tlApp {
                    self.appToOpen = ""
                    self.corner = false
                    return
                }
            case "tr":
                if !self.cornerCheck(cornerType: "tr") && self.appToOpen == trApp {
                    self.appToOpen = ""
                    self.corner = false
                    return
                }
            default:
                self.appToOpen = ""
                self.corner = false
                return
            }

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

    func firstStartupCheck() {
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
        let isRunning = !NSWorkspace.shared.runningApplications.filter { $0.bundleIdentifier == launcherBundleID }.isEmpty

        SMLoginItemSetEnabled(launcherBundleID as CFString, startup)

        if isRunning {
            DistributedNotificationCenter.default().post(name: Notification.Name("killLauncher"), object: Bundle.main.bundleIdentifier!)
            if !startup {
                NSApp.terminate(self)
            }
        }
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

