//
//  main.swift
//  HotApps
//
//  Created by SkyrilHD on 28.11.22.
//

import AppKit.NSApplication

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.hide(nil)
app.setActivationPolicy(.accessory)

NSApplication.shared.run()
