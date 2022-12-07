//
//  Settings.swift
//  HotApps
//
//  Created by SkyrilHD on 29.11.22.
//  Copyright © 2022 SkyrilHD. All rights reserved.
//

import Cocoa
import ServiceManagement

class Settings: NSWindowController, NSWindowDelegate, NSTextFieldDelegate {
    let tlButton = NSButton()
    var tlLabel = NSTextField()
    let tlSelect = NSButton()

    let trButton = NSButton()
    var trLabel = NSTextField()
    let trSelect = NSButton()
    
    let blButton = NSButton()
    var blLabel = NSTextField()
    let blSelect = NSButton()

    let brButton = NSButton()
    var brLabel = NSTextField()
    let brSelect = NSButton()

    var msDelayLabel = NSTextField()
    var msDelayText = NSTextField()

    var delayHideSetting = NSButton()

    var hideSetting = NSButton()

    var startupSetting = NSButton()

    var largestPath: CGFloat = 0

    override init(window: NSWindow?) {
        super.init(window: window)
        self.window = window
        windowDidLoad()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window = NSWindow(contentRect: NSMakeRect(100, 100, NSScreen.main!.frame.width/2, NSScreen.main!.frame.height/2), styleMask: [.closable, .titled], backing: NSWindow.BackingStoreType.buffered, defer: false)

        self.window?.level = NSWindow.Level.floating
        self.window?.title = "HotApps Settings"

        self.window?.delegate = self

        appSettings()

        self.window!.setContentSize(NSSize(width: tlSelect.frame.maxX+20, height: self.window!.frame.height-brSelect.frame.minY+100))

        appSettings()
        self.window?.center()
    }

    func topLeftSettings() {
        // 'Top-left corner' toggle
        tlButton.title = "Enable top-left corner"
        tlButton.setButtonType(.switch)
        tlButton.font = NSFont(name: ".AppleSystemUIFont", size: 13)
        tlButton.sizeToFit()
        tlButton.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 80)-80, width: brButton.frame.width, height: tlButton.frame.height)
        tlButton.tag = 1
        tlButton.state = tlEnabled ? .on : .off
        tlButton.action = #selector(self.cornerSwitch(_:))
        self.window?.contentView?.addSubview(tlButton)

        // 'Top-left corner' application path label
        genericSettings(type: tlLabel, status: tlEnabled, input: tlApp)
        tlLabel.frame = CGRect(x: tlButton.frame.maxX+50, y: tlButton.frame.maxY-(tlLabel.frame.height), width: largestPath, height: tlLabel.frame.height)

        // 'Top-left corner' Select button
        genericSettings(type: tlSelect, status: tlEnabled, input: nil)
        tlSelect.frame = CGRect(x: tlLabel.frame.maxX+50, y: tlLabel.frame.midY-tlSelect.frame.height/2, width: tlSelect.frame.width, height: tlSelect.frame.height)
        tlSelect.tag = 1
    }

    func topRightSettings() {
        // 'Top-right corner' toggle
        trButton.title = "Enable top-right corner"
        trButton.setButtonType(.switch)
        trButton.font = NSFont(name: ".AppleSystemUIFont", size: 13)
        trButton.sizeToFit()
        trButton.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 110)-110, width: brButton.frame.width, height: trButton.frame.height)
        trButton.tag = 2
        trButton.state = trEnabled ? .on : .off
        trButton.action = #selector(self.cornerSwitch(_:))
        self.window?.contentView?.addSubview(trButton)

        // 'Top-right corner' application path label
        genericSettings(type: trLabel, status: trEnabled, input: trApp)
        trLabel.frame = CGRect(x: trButton.frame.maxX+50, y: trButton.frame.maxY-(trLabel.frame.height), width: largestPath, height: trLabel.frame.height)

        // 'Top-right corner' Select button
        genericSettings(type: trSelect, status: trEnabled, input: nil)
        trSelect.frame = CGRect(x: trLabel.frame.maxX+50, y: trLabel.frame.midY-trSelect.frame.height/2, width: trSelect.frame.width, height: trSelect.frame.height)
        trSelect.tag = 2
    }

    func bottomLeftSettings() {
        // 'Bottom-left corner' toggle
        blButton.title = "Enable bottom-left corner"
        blButton.setButtonType(.switch)
        blButton.font = NSFont(name: ".AppleSystemUIFont", size: 13)
        blButton.sizeToFit()
        blButton.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 140)-140, width: brButton.frame.width, height: blButton.frame.height)
        blButton.tag = 3
        blButton.state = blEnabled ? .on : .off
        blButton.action = #selector(self.cornerSwitch(_:))
        self.window?.contentView?.addSubview(blButton)

        // 'Botton-left corner' application path label
        genericSettings(type: blLabel, status: blEnabled, input: blApp)
        blLabel.frame = CGRect(x: blButton.frame.maxX+50, y: blButton.frame.maxY-(blLabel.frame.height), width: largestPath, height: blLabel.frame.height)

        // 'Bottom-left corner' Select button
        genericSettings(type: blSelect, status: blEnabled, input: nil)
        blSelect.frame = CGRect(x: blLabel.frame.maxX+50, y: blLabel.frame.midY-blSelect.frame.height/2, width: blSelect.frame.width, height: blSelect.frame.height)
        blSelect.tag = 3
    }

    func bottomRightSettings() {
        // 'Bottom-right corner' toggle
        brButton.title = "Enable bottom-right corner"
        brButton.setButtonType(.switch)
        brButton.font = NSFont(name: ".AppleSystemUIFont", size: 13)
        brButton.sizeToFit()
        brButton.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 170)-170, width: brButton.frame.width, height: brButton.frame.height)
        brButton.tag = 4
        brButton.state = brEnabled ? .on : .off
        brButton.action = #selector(self.cornerSwitch(_:))
        self.window?.contentView?.addSubview(brButton)

        // 'Bottom-right corner' application path label
        genericSettings(type: brLabel, status: brEnabled, input: brApp)
        brLabel.frame = CGRect(x: brButton.frame.maxX+50, y: brButton.frame.maxY-(brLabel.frame.height), width: largestPath, height: brLabel.frame.height)

        // 'Bottom-right corner' Select button
        genericSettings(type: brSelect, status: brEnabled, input: nil)
        brSelect.frame = CGRect(x: brLabel.frame.maxX+50, y: brLabel.frame.midY-brSelect.frame.height/2, width: brSelect.frame.width, height: brSelect.frame.height)
        brSelect.tag = 4
    }

    func cleanName(input: String) -> String {
        return input.components(separatedBy: "/").last!
    }

    func getLargestPath() -> CGFloat {
        var largestValue: CGFloat
        largestValue = getStringSize(content: cleanName(input: tlApp))
        if (largestValue < getStringSize(content: cleanName(input: trApp))) {
            largestValue = getStringSize(content: cleanName(input: trApp))
        }
        if (largestValue < getStringSize(content: cleanName(input: blApp))) {
            largestValue = getStringSize(content: cleanName(input: blApp))
        }
        if (largestValue < getStringSize(content: cleanName(input: brApp))) {
            largestValue = getStringSize(content: cleanName(input: brApp))
        }
        return largestValue+20
    }

    func getStringSize(content: String) -> CGFloat {
        let font = NSFont(name: ".AppleSystemUIFont", size: 13)
        return content.size(withAttributes: [.font: font!, .paragraphStyle: NSMutableParagraphStyle()]).width.rounded()
    }

    func appSettings() {
        largestPath = getLargestPath()
        delaySettings()
        hideSettings()
        startupSettings()
        bottomRightSettings()
        bottomLeftSettings()
        topRightSettings()
        topLeftSettings()
    }

    func delaySettings() {
        msDelayLabel.stringValue = "Detection delay (in ms):"
        msDelayLabel.font = NSFont(name: ".AppleSystemUIFont", size: 13)
        msDelayLabel.sizeToFit()
        msDelayLabel.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 220)-220, width: msDelayLabel.frame.width, height: msDelayLabel.frame.height)
        msDelayLabel.isEditable = false
        msDelayLabel.isSelectable = false
        msDelayLabel.isBordered = false
        msDelayLabel.isBezeled = false
        msDelayLabel.drawsBackground = false
        self.window?.contentView?.addSubview(msDelayLabel)

        msDelayText.sizeToFit()
        msDelayText.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 240)-240, width: 40, height: msDelayText.frame.height)
        msDelayText.stringValue = String(msDelay)
        msDelayText.isEditable = true
        msDelayText.delegate = self
        self.window?.contentView?.addSubview(msDelayText)

        delayHideSetting.title = "Apply delay when hiding apps"
        delayHideSetting.setButtonType(.switch)
        delayHideSetting.font = NSFont(name: ".AppleSystemUIFont", size: 13)
        delayHideSetting.sizeToFit()
        delayHideSetting.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 220)-270, width: delayHideSetting.frame.width, height: delayHideSetting.frame.height)
        delayHideSetting.state = delayHide ? .on : .off
        delayHideSetting.action = #selector(self.delayHideSwitch(_:))
        self.window?.contentView?.addSubview(delayHideSetting)
    }

    func hideSettings() {
        hideSetting.title = "Hide from status bar"
        hideSetting.setButtonType(.switch)
        hideSetting.font = NSFont(name: ".AppleSystemUIFont", size: 13)
        hideSetting.sizeToFit()
        hideSetting.frame = CGRect(x: ((self.window?.frame.width)!)-hideSetting.frame.width-20, y: (self.window?.frame.height ?? 220)-220, width: hideSetting.frame.width, height: hideSetting.frame.height)
        hideSetting.state = hideStatusBar ? .on : .off
        hideSetting.action = #selector(self.hideStatusBarSwitch(_:))
        self.window?.contentView?.addSubview(hideSetting)
    }

    func startupSettings() {
        startupSetting.title = "Launch on Login"
        startupSetting.setButtonType(.switch)
        startupSetting.font = NSFont(name: ".AppleSystemUIFont", size: 13)
        startupSetting.sizeToFit()
        startupSetting.frame = CGRect(x: ((self.window?.frame.width)!)-hideSetting.frame.width-20, y: (self.window?.frame.height ?? 220)-250, width: startupSetting.frame.width, height: startupSetting.frame.height)
        startupSetting.state = startup ? .on : .off
        startupSetting.action = #selector(self.startupSwitch(_:))
        self.window?.contentView?.addSubview(startupSetting)
    }

    func controlTextDidChange(_ obj: Notification) {
        if msDelayText.stringValue.count > 4 {
            msDelayText.stringValue = String(msDelay)
        }
        if CharacterSet(charactersIn: msDelayText.stringValue).isSubset(of: .decimalDigits) {
            if !msDelayText.stringValue.isEmpty {
                msDelay = Int(msDelayText.stringValue)!
                UserDefaults.standard.set(msDelay, forKey: "msDelay")
            }
        } else {
            msDelayText.stringValue = String(msDelayText.stringValue.dropLast(1))
        }
    }

    func genericSettings(type: NSControl, status: Bool, input: String?) {
        if type.isKind(of: NSTextField.self) {
            let textField: NSTextField = type as! NSTextField
            textField.stringValue = self.cleanName(input: input!)
            textField.isEditable = false
            textField.isSelectable = false
            textField.isEnabled = status
            textField.sizeToFit()
            textField.alignment = NSTextAlignment.center
            textField.font = NSFont(name: ".AppleSystemUIFont", size: 13)
            self.window?.contentView?.addSubview(textField)
        } else if type.isKind(of: NSButton.self) {
            let button: NSButton = type as! NSButton
            button.title = "Select"
            button.setButtonType(.momentaryPushIn)
            button.target = self
            button.isEnabled = status
            button.bezelStyle = .rounded
            button.font = NSFont(name: ".AppleSystemUIFont", size: 13)
            button.sizeToFit()
            button.action = #selector(self.openDocument(_:))
            self.window?.contentView?.addSubview(button)
        }
    }

    @objc func openDocument(_ button: NSButton) {
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = ["app"]
        openPanel.level = .modalPanel
        let panelResponse = openPanel.runModal()
        if panelResponse == NSApplication.ModalResponse.OK {
            let selPath = openPanel.url!.relativeString.dropFirst(7).dropLast(1).replacingOccurrences(of: "%20", with: " ")
            switch button.tag {
            case 1:
                tlApp = selPath
                tlLabel.stringValue = selPath
                UserDefaults.standard.set(tlApp, forKey: "tlApp")
            case 2:
                trApp = selPath
                trLabel.stringValue = selPath
                UserDefaults.standard.set(trApp, forKey: "trApp")
            case 3:
                blApp = selPath
                blLabel.stringValue = selPath
                UserDefaults.standard.set(blApp, forKey: "blApp")
            case 4:
                brApp = selPath
                brLabel.stringValue = selPath
                UserDefaults.standard.set(brApp, forKey: "brApp")
            default:
                break
            }
            appSettings()
            self.window!.setContentSize(NSSize(width: tlSelect.frame.maxX+20, height: self.window!.frame.height-brSelect.frame.minY+100))
            self.window!.center()
            appSettings()
            StatusBar().update()
        }
    }

    @objc func cornerSwitch(_ button: NSButton) {
        switch button.tag {
        case 1:
            tlEnabled = tlButton.state == .on
            tlLabel.isEnabled = tlEnabled
            tlSelect.isEnabled = tlEnabled
            UserDefaults.standard.set(tlEnabled, forKey: "tlEnabled")
        case 2:
            trEnabled = trButton.state == .on
            trLabel.isEnabled = trEnabled
            trSelect.isEnabled = trEnabled
            UserDefaults.standard.set(trEnabled, forKey: "trEnabled")
        case 3:
            blEnabled = blButton.state == .on
            blLabel.isEnabled = blEnabled
            blSelect.isEnabled = blEnabled
            UserDefaults.standard.set(blEnabled, forKey: "blEnabled")
        case 4:
            brEnabled = brButton.state == .on
            brLabel.isEnabled = brEnabled
            brSelect.isEnabled = brEnabled
            UserDefaults.standard.set(brEnabled, forKey: "brEnabled")
        default:
            break
        }
        StatusBar().update()
    }

    @objc func delayHideSwitch(_ button: NSButton) {
        delayHide = button.state == .on
        UserDefaults.standard.set(delayHide, forKey: "delayHide")
    }

    @objc func hideStatusBarSwitch(_ button: NSButton) {
        hideStatusBar = button.state == .on
        UserDefaults.standard.set(hideStatusBar, forKey: "hideStatusBar")
        StatusBar().hide(status: hideStatusBar)
    }

    @objc func startupSwitch(_ button: NSButton) {
        startup = button.state == .on
        UserDefaults.standard.set(startup, forKey: "startup")
        AppDelegate().startupCheck()
    }
}
