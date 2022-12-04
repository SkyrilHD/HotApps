//
//  StatusBar.swift
//  HotApps
//
//  Created by SkyrilHD on 28.11.22.
//

import AppKit

let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

class StatusBar: AppDelegate {
    override init() {
        // Set icon for status bar
        statusItem.button?.image = NSImage(named: "StatusIcon")
        statusItem.button?.image?.size = NSSize(width: 32, height: 32)

        // Create empty menu
        let nsmenu = NSMenu()

        // 'About HotApps'
        nsmenu.addItem(withTitle: "About HotApps", action: #selector(AppDelegate().aboutApp), keyEquivalent: "")

        nsmenu.addItem(NSMenuItem.separator())

        // Show which apps are being used
        nsmenu.addItem(withTitle: "Current App:", action: nil, keyEquivalent: "")
        nsmenu.addItem(withTitle: tlApp, action: nil, keyEquivalent: "")

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
}
