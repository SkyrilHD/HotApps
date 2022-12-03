//
//  AboutApp.swift
//  HotApps
//
//  Created by SkyrilHD on 28.11.22.
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
        if ((NSImage(named: "AppIcon")?.isValid) != nil) {
            let appIcon = NSImageView(frame: NSRect(x: ((window?.frame.width)!/2-(NSImage(named: "AppIcon")?.size.width)!/2), y: ((window?.frame.height)!/2-(NSImage(named: "AppIcon")?.size.height)!/2)+30, width: (NSImage(named: "AppIcon")?.size.width)!, height: (NSImage(named: "AppIcon")?.size.height)!))
            appIcon.image = NSImage(named: "AppIcon")
            window!.contentView?.addSubview(appIcon)
        }

        // Add text to window
        let aboutText = NSTextField(string: "Version: \(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)\n\nCopyright © 2022 SkyrilHD\nAll rights reserved")
        aboutText.isEditable = false
        aboutText.isSelectable = false
        aboutText.isBezeled = false
        aboutText.drawsBackground = false
        aboutText.alignment = NSTextAlignment.center
        aboutText.font = NSFont.userFont(ofSize: 12)
        aboutText.frame = CGRect(x: ((window?.frame.width)!/2-175/2), y: ((window?.frame.height)!/2-130), width: 175, height: 80)
        window?.contentView?.addSubview(aboutText)

        // Show 'About HotApps' window
        NSWindowController(window: window).showWindow(self)
    }
}
