//
//  StatusBar.swift
//  HotApps
//
//  Created by SkyrilHD on 28.11.22.
//  Copyright © 2022 SkyrilHD. All rights reserved.
//

import AppKit

var statusItem = NSStatusItem()

class StatusBar {
    let appSettings = AppSettings.shared

    init() {
        if !appSettings.hideStatusBar {
            add()
        }
    }

    func add() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        // Set icon for status bar
        if #available(macOS 10.10, *) {
            statusItem.button?.image = NSImage(named: "StatusIcon")
            statusItem.button?.image?.size = NSSize(width: 32, height: 32)
        } else {
            // Fallback on earlier versions
            statusItem.image = NSImage(named: "StatusIcon")
            statusItem.image?.size = NSSize(width: 32, height: 32)
        }

        // Create empty menu
        let nsmenu = NSMenu()

        // 'About HotApps'
        let aboutItem = NSMenuItem(title: NSLocalizedString("about_hotapps", comment: ""),
                       action: #selector(AppDelegate.openAboutApp), keyEquivalent: "")
        aboutItem.target = NSApp.delegate
        nsmenu.addItem(aboutItem)

        nsmenu.addItem(NSMenuItem.separator())

        // Show which apps are being used
        nsmenu.addItem(withTitle: NSLocalizedString("current_hotapps", comment: "")+":", action: nil, keyEquivalent: "")

        let tlStatus = appSettings.tlEnabled ? appSettings.tlApp.components(separatedBy: "/").last! : NSLocalizedString("disabled", comment: "")
        nsmenu.addItem(withTitle: "\t\(NSLocalizedString("top-left_statusbar", comment: "")): "+tlStatus,
                       action: nil, keyEquivalent: "")

        let trStatus = appSettings.trEnabled ? appSettings.trApp.components(separatedBy: "/").last! : NSLocalizedString("disabled", comment: "")
        nsmenu.addItem(withTitle: "\t\(NSLocalizedString("top-right_statusbar", comment: "")): "+trStatus,
                       action: nil, keyEquivalent: "")

        let blStatus = appSettings.blEnabled ? appSettings.blApp.components(separatedBy: "/").last! : NSLocalizedString("disabled", comment: "")
        nsmenu.addItem(withTitle: "\t\(NSLocalizedString("bottom-left_statusbar", comment: "")): "+blStatus,
                       action: nil, keyEquivalent: "")

        let brStatus = appSettings.brEnabled ? appSettings.brApp.components(separatedBy: "/").last! : NSLocalizedString("disabled", comment: "")
        nsmenu.addItem(withTitle: "\t\(NSLocalizedString("bottom-right_statusbar", comment: "")): "+brStatus,
                       action: nil, keyEquivalent: "")

        nsmenu.addItem(NSMenuItem.separator())

        // 'Settings'
        let settingsItem = NSMenuItem(title: NSLocalizedString("settings", comment: ""),
                       action: #selector(AppDelegate.openSettings), keyEquivalent: "")
        settingsItem.target = NSApp.delegate
        nsmenu.addItem(settingsItem)

        nsmenu.addItem(NSMenuItem.separator())

        // 'Quit'
        nsmenu.addItem(withTitle: NSLocalizedString("quit", comment: ""),
                       action: #selector(NSApplication.terminate(_:)), keyEquivalent: "")

        // Apply NSMenu to status bar
        statusItem.menu = nsmenu
    }

    func update() {
        statusItem.view?.updateLayer()
    }

    func hide(status: Bool) {
        status ? NSStatusBar.system.removeStatusItem(statusItem) : add()
    }
}
