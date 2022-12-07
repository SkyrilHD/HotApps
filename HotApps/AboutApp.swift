//
//  AboutApp.swift
//  HotApps
//
//  Created by SkyrilHD on 28.11.22.
//  Copyright © 2022 SkyrilHD. All rights reserved.
//

import Cocoa

class AboutApp: AppDelegate {
    var window: NSWindow?

    override init() {
        super.init()

        // Create empty window
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 220, height: 240),
            styleMask: [.closable, .titled],
            backing: .buffered, defer: false)
        window!.center()
        window!.level = NSWindow.Level.modalPanel
        window?.title = "About HotApps"

        // Add logo to window
        if let appIconImage = NSImage(named: "AppIcon"), appIconImage.isValid {
            let appIcon = NSImageView(frame: NSRect(x: ((window?.frame.width)!/2-(appIconImage.size.width)/2), y: ((window?.frame.height)!/2-(appIconImage.size.height)/2)+30, width: (appIconImage.size.width), height: (appIconImage.size.height)))
            appIcon.image = appIconImage
            window!.contentView?.addSubview(appIcon)
        }

        // Add text to window
        let year = Calendar.current.component(.year, from: Date())
        let aboutText = NSTextField()
        aboutText.stringValue = "Version: \(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)\n\nCopyright © \(year) SkyrilHD\nAll rights reserved"
        aboutText.isEditable = false
        aboutText.isSelectable = false
        aboutText.isBezeled = false
        aboutText.drawsBackground = false
        aboutText.alignment = NSTextAlignment.center
        aboutText.font = NSFont.userFont(ofSize: 12)
        aboutText.frame = NSRect(x: ((window?.frame.width)!/2-(aboutText.fittingSize.width)/2), y: ((window?.frame.height)!/3-(aboutText.fittingSize.height)), width: aboutText.fittingSize.width, height: aboutText.fittingSize.height)
        window?.contentView?.addSubview(aboutText)

        // Show 'About HotApps' window
        NSWindowController(window: window).showWindow(self)
    }
}
