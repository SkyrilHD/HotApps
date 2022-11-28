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
        let aboutItem = NSMenuItem()
        aboutItem.title = "About HotApps"
        aboutItem.action = #selector(AppDelegate().aboutApp)
        nsmenu.addItem(aboutItem)

        nsmenu.addItem(NSMenuItem.separator())

        // Show which apps are being used
        let currentLabelItem = NSMenuItem()
        currentLabelItem.title = "Current App:"
        nsmenu.addItem(currentLabelItem)

        let currentBLItem = NSMenuItem()
        currentBLItem.title = blApp
        nsmenu.addItem(currentBLItem)

        nsmenu.addItem(NSMenuItem.separator())

        // 'Settings'
        let settingsItem = NSMenuItem()
        settingsItem.title = "Settings"
        nsmenu.addItem(settingsItem)

        nsmenu.addItem(NSMenuItem.separator())

        // 'Quit'
        let quitItem = NSMenuItem()
        quitItem.title = "Quit"
        quitItem.action = #selector(NSApplication.terminate(_:))
        nsmenu.addItem(quitItem)

        // Apply NSMenu to status bar
        statusItem.menu = nsmenu
    }
}
