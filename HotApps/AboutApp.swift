//
//  AboutApp.swift
//  HotApps
//
//  Created by SkyrilHD on 28.11.22.
//  Copyright © 2022 SkyrilHD. All rights reserved.
//

import Cocoa

class AboutApp: NSWindowController, NSWindowDelegate {
    init() {
        // Create empty window
        let aboutAppWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 220, height: 240),
            styleMask: [.closable, .titled],
            backing: .buffered, defer: false)

        aboutAppWindow.center()
        aboutAppWindow.level = .modalPanel
        aboutAppWindow.title = NSLocalizedString("about_hotapps", comment: "")

        // Add logo to window
        if let appIconImage = NSImage(named: "AppIcon"), appIconImage.isValid {
            let appIcon = NSImageView(frame: NSRect(x: ((aboutAppWindow.frame.width)/2-(appIconImage.size.width)/2),
                                                    y: ((aboutAppWindow.frame.height)/2-(appIconImage.size.height)/2)+30,
                                                    width: (appIconImage.size.width), height: (appIconImage.size.height)))
            appIcon.image = appIconImage
            aboutAppWindow.contentView?.addSubview(appIcon)
        }

        // Add text to window
        let year = Calendar.current.component(.year, from: Date())
        let aboutText = NSTextField()
        aboutText.stringValue = "Version: \(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)\n\n"
                                + "Copyright © \(year) SkyrilHD\n"
                                + NSLocalizedString("all_rights_reserved", comment: "")
        aboutText.isEditable = false
        aboutText.isSelectable = false
        aboutText.isBezeled = false
        aboutText.drawsBackground = false
        aboutText.alignment = NSTextAlignment.center
        aboutText.font = NSFont.userFont(ofSize: 12)
        aboutText.frame = NSRect(x: ((aboutAppWindow.frame.width)/2-(aboutText.fittingSize.width)/2),
                                 y: ((aboutAppWindow.frame.height)/3-(aboutText.fittingSize.height)),
                                 width: aboutText.fittingSize.width,
                                 height: aboutText.fittingSize.height)
        aboutAppWindow.contentView?.addSubview(aboutText)

        super.init(window: aboutAppWindow)
        windowDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func windowWillClose(_ notification: Notification) {
        (NSApp.delegate as? AppDelegate)?.aboutApp = nil
    }
}
