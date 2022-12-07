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

    init() {
        if !hideStatusBar {
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
        nsmenu.addItem(withTitle: "About HotApps", action: #selector(AppDelegate().aboutApp), keyEquivalent: "")

        nsmenu.addItem(NSMenuItem.separator())

        // Show which apps are being used
        nsmenu.addItem(withTitle: "Current HotApps:", action: nil, keyEquivalent: "")

        let tlStatus = tlEnabled ? tlApp.components(separatedBy: "/").last! : "Disabled"
        nsmenu.addItem(withTitle: "\tTop-left: "+tlStatus, action: nil, keyEquivalent: "")

        let trStatus = trEnabled ? trApp.components(separatedBy: "/").last! : "Disabled"
        nsmenu.addItem(withTitle: "\tTop-right: "+trStatus, action: nil, keyEquivalent: "")

        let blStatus = blEnabled ? blApp.components(separatedBy: "/").last! : "Disabled"
        nsmenu.addItem(withTitle: "\tBottom-left: "+blStatus, action: nil, keyEquivalent: "")
        
        let brStatus = brEnabled ? brApp.components(separatedBy: "/").last! : "Disabled"
        nsmenu.addItem(withTitle: "\tBottom-right: "+brStatus, action: nil, keyEquivalent: "")

        nsmenu.addItem(NSMenuItem.separator())

        // 'Settings'
        nsmenu.addItem(withTitle: "Settings", action: #selector(AppDelegate().openSettings), keyEquivalent: "")

        nsmenu.addItem(NSMenuItem.separator())

        // 'Quit'
        nsmenu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "")

        // Apply NSMenu to status bar
        statusItem.menu = nsmenu
    }

    func update() {
        statusItem.view?.updateLayer()
    }

    func hide(status: Bool) {
        if status {
            NSStatusBar.system.removeStatusItem(statusItem)
        } else {
            add()
        }
    }
}
