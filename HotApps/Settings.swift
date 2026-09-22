//
//  Settings.swift
//  HotApps
//
//  Created by SkyrilHD on 29.11.22.
//  Copyright © 2022 SkyrilHD. All rights reserved.
//

import Cocoa
import ServiceManagement

@propertyWrapper
struct Setting<Value> {
    let key: String
    let defaultValue: Value
    var storage: UserDefaults = .standard

    var wrappedValue: Value {
        get { storage.object(forKey: key) as? Value ?? defaultValue }
        set { storage.setValue(newValue, forKey: key) }
    }
}

struct AppSettings {
    static var shared = AppSettings()

    // Apps
    @Setting(key: "blApp", defaultValue: "") var blApp: String
    @Setting(key: "brApp", defaultValue: "") var brApp: String
    @Setting(key: "tlApp", defaultValue: "") var tlApp: String
    @Setting(key: "trApp", defaultValue: "") var trApp: String

    // Toggles
    @Setting(key: "blEnabled", defaultValue: false) var blEnabled: Bool
    @Setting(key: "brEnabled", defaultValue: false) var brEnabled: Bool
    @Setting(key: "tlEnabled", defaultValue: false) var tlEnabled: Bool
    @Setting(key: "trEnabled", defaultValue: false) var trEnabled: Bool

    // Settings
    @Setting(key: "msDelay", defaultValue: 125) var msDelay: Int
    @Setting(key: "delayHide", defaultValue: true) var delayHide: Bool
    @Setting(key: "hideStatusBar", defaultValue: false) var hideStatusBar: Bool
    @Setting(key: "startup", defaultValue: false) var startup: Bool
}

class Settings: NSWindowController, NSWindowDelegate {
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

    var appSettings = AppSettings.shared

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
        let screenFrame = NSScreen.main?.frame ?? NSRect(x: 100, y: 100, width: 800, height: 600)
        window = NSWindow(contentRect: NSRect(x: 100, y: 100, width: screenFrame.width/2,
                                                   height: screenFrame.height/2),
                               styleMask: [.closable, .titled], backing: NSWindow.BackingStoreType.buffered,
                               defer: false)

        window?.level = NSWindow.Level.floating
        window?.title = NSLocalizedString("hotapps_settings", comment: "")

        window?.delegate = self

        updateView()
    }

    func windowWillClose(_ notification: Notification) {
        (NSApp.delegate as? AppDelegate)?.settings = nil
    }

    func topLeftSettings() {
        // 'Top-left corner' toggle
        genericSettings(type: tlButton, status: appSettings.tlEnabled,
                        input: NSLocalizedString("enable_tl_corner_setting", comment: ""), checkbox: true)
        tlButton.frame = CGRect(x: 20, y: window!.frame.height-80,
                                width: brButton.frame.width, height: tlButton.frame.height)
        tlButton.tag = 1

        // 'Top-left corner' application path label
        genericSettings(type: tlLabel, status: appSettings.tlEnabled, input: appSettings.tlApp, checkbox: nil)
        tlLabel.frame = CGRect(x: tlButton.frame.maxX+50, y: tlButton.frame.maxY-(tlLabel.frame.height),
                               width: largestPath, height: tlLabel.frame.height)

        // 'Top-left corner' Select button
        genericSettings(type: tlSelect, status: appSettings.tlEnabled, input: nil, checkbox: false)
        tlSelect.frame = CGRect(x: tlLabel.frame.maxX+50, y: tlLabel.frame.midY-tlSelect.frame.height/2,
                                width: tlSelect.frame.width, height: tlSelect.frame.height)
        tlSelect.tag = 1
    }

    func topRightSettings() {
        // 'Top-right corner' toggle
        genericSettings(type: trButton, status: appSettings.trEnabled,
                        input: NSLocalizedString("enable_tr_corner_setting", comment: ""), checkbox: true)
        trButton.frame = CGRect(x: 20, y: window!.frame.height-110,
                                width: brButton.frame.width, height: trButton.frame.height)
        trButton.tag = 2

        // 'Top-right corner' application path label
        genericSettings(type: trLabel, status: appSettings.trEnabled, input: appSettings.trApp, checkbox: nil)
        trLabel.frame = CGRect(x: trButton.frame.maxX+50, y: trButton.frame.maxY-(trLabel.frame.height),
                               width: largestPath, height: trLabel.frame.height)

        // 'Top-right corner' Select button
        genericSettings(type: trSelect, status: appSettings.trEnabled, input: nil, checkbox: false)
        trSelect.frame = CGRect(x: trLabel.frame.maxX+50, y: trLabel.frame.midY-trSelect.frame.height/2,
                                width: trSelect.frame.width, height: trSelect.frame.height)
        trSelect.tag = 2
    }

    func bottomLeftSettings() {
        // 'Bottom-left corner' toggle
        genericSettings(type: blButton, status: appSettings.blEnabled,
                        input: NSLocalizedString("enable_bl_corner_setting", comment: ""), checkbox: true)
        blButton.frame = CGRect(x: 20, y: window!.frame.height-140,
                                width: brButton.frame.width, height: blButton.frame.height)
        blButton.tag = 3

        // 'Botton-left corner' application path label
        genericSettings(type: blLabel, status: appSettings.blEnabled, input: appSettings.blApp, checkbox: nil)
        blLabel.frame = CGRect(x: blButton.frame.maxX+50, y: blButton.frame.maxY-(blLabel.frame.height),
                               width: largestPath, height: blLabel.frame.height)

        // 'Bottom-left corner' Select button
        genericSettings(type: blSelect, status: appSettings.blEnabled, input: nil, checkbox: false)
        blSelect.frame = CGRect(x: blLabel.frame.maxX+50, y: blLabel.frame.midY-blSelect.frame.height/2,
                                width: blSelect.frame.width, height: blSelect.frame.height)
        blSelect.tag = 3
    }

    func bottomRightSettings() {
        // 'Bottom-right corner' toggle
        genericSettings(type: brButton, status: appSettings.brEnabled,
                        input: NSLocalizedString("enable_br_corner_setting", comment: ""), checkbox: true)
        brButton.frame = CGRect(x: 20, y: window!.frame.height-170,
                                width: brButton.frame.width, height: brButton.frame.height)
        brButton.tag = 4

        // 'Bottom-right corner' application path label
        genericSettings(type: brLabel, status: appSettings.brEnabled, input: appSettings.brApp, checkbox: nil)
        brLabel.frame = CGRect(x: brButton.frame.maxX+50, y: brButton.frame.maxY-(brLabel.frame.height),
                               width: largestPath, height: brLabel.frame.height)

        // 'Bottom-right corner' Select button
        genericSettings(type: brSelect, status: appSettings.brEnabled, input: nil, checkbox: false)
        brSelect.frame = CGRect(x: brLabel.frame.maxX+50, y: brLabel.frame.midY-brSelect.frame.height/2,
                                width: brSelect.frame.width, height: brSelect.frame.height)
        brSelect.tag = 4
    }

    func cleanName(input: String) -> String {
        return input.components(separatedBy: "/").last!
    }

    func getLargestPath() -> CGFloat {
        var largestValue: CGFloat
        largestValue = getStringSize(content: cleanName(input: appSettings.tlApp))
        if largestValue < getStringSize(content: cleanName(input: appSettings.trApp)) {
            largestValue = getStringSize(content: cleanName(input: appSettings.trApp))
        }
        if largestValue < getStringSize(content: cleanName(input: appSettings.blApp)) {
            largestValue = getStringSize(content: cleanName(input: appSettings.blApp))
        }
        if largestValue < getStringSize(content: cleanName(input: appSettings.brApp)) {
            largestValue = getStringSize(content: cleanName(input: appSettings.brApp))
        }
        return largestValue+20
    }

    func getStringSize(content: String) -> CGFloat {
        let font = NSFont(name: ".AppleSystemUIFont", size: 13)
        return content.size(withAttributes: [.font: font!, .paragraphStyle: NSMutableParagraphStyle()]).width.rounded()
    }

    func appSettingsUI() {
        largestPath = getLargestPath()
        delaySettings()
        hideSettings()
        startupSettings()
        bottomRightSettings()
        bottomLeftSettings()
        topRightSettings()
        topLeftSettings()
    }

    func hideSettings() {
        genericSettings(type: hideSetting, status: appSettings.hideStatusBar,
                        input: NSLocalizedString("hide_statusbar", comment: ""), checkbox: true)
        hideSetting.frame = CGRect(x: window!.frame.width-hideSetting.frame.width-20,
                                   y: window!.frame.height-220, width: hideSetting.frame.width,
                                   height: hideSetting.frame.height)
        hideSetting.action = #selector(hideStatusBarSwitch(_:))
    }

    func startupSettings() {
        genericSettings(type: startupSetting, status: appSettings.startup,
                        input: NSLocalizedString("launch_on_login", comment: ""), checkbox: true)
        startupSetting.frame = CGRect(x: window!.frame.width-hideSetting.frame.width-20,
                                      y: window!.frame.height-250, width: startupSetting.frame.width,
                                      height: startupSetting.frame.height)
        startupSetting.action = #selector(startupSwitch(_:))
    }

    func genericSettings(type: NSControl, status: Bool, input: String?, checkbox: Bool? = false) {
        if let textField = type as? NSTextField {
            textField.stringValue = cleanName(input: input ?? "")
            textField.isEditable = false
            textField.isSelectable = false
            textField.isEnabled = status
            textField.sizeToFit()
            textField.alignment = NSTextAlignment.center
            textField.font = NSFont(name: ".AppleSystemUIFont", size: 13)
            window?.contentView?.addSubview(textField)
        } else if let button = type as? NSButton {
            if let isCheckbox = checkbox, isCheckbox {
                button.title = input ?? ""
                button.setButtonType(.switch)
                button.state = status ? .on : .off
                button.action = #selector(cornerSwitch(_:))
            } else {
                button.title = NSLocalizedString("select", comment: "")
                button.setButtonType(.momentaryPushIn)
                button.target = self
                button.isEnabled = status
                button.bezelStyle = .rounded
                button.action = #selector(openDocument(_:))
            }
            button.font = NSFont(name: ".AppleSystemUIFont", size: 13)
            button.sizeToFit()
            window?.contentView?.addSubview(button)
        }
    }

    func updateView() {
        appSettingsUI()
        window!.setContentSize(NSSize(width: tlSelect.frame.maxX+20,
                                           height: window!.frame.height-brSelect.frame.minY+100))
        window!.center()
        appSettingsUI()
    }

    @objc func openDocument(_ button: NSButton) {
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = ["app"]
        openPanel.directoryURL = URL(fileURLWithPath: "/Applications")
        openPanel.level = .modalPanel
        let panelResponse = openPanel.runModal()
        if panelResponse == NSApplication.ModalResponse.OK {
            guard let url = openPanel.url else { return }
            let selPath = url.cleanBundleURL

            switch button.tag {
            case 1:
                appSettings.tlApp = selPath
                tlLabel.stringValue = selPath
            case 2:
                appSettings.trApp = selPath
                trLabel.stringValue = selPath
            case 3:
                appSettings.blApp = selPath
                blLabel.stringValue = selPath
            case 4:
                appSettings.brApp = selPath
                brLabel.stringValue = selPath
            default:
                break
            }
            updateView()
            StatusBar().update()
        }
    }

    @objc func cornerSwitch(_ button: NSButton) {
        switch button.tag {
        case 1:
            appSettings.tlEnabled = tlButton.state == .on
            tlLabel.isEnabled = appSettings.tlEnabled
            tlSelect.isEnabled = appSettings.tlEnabled
        case 2:
            appSettings.trEnabled = trButton.state == .on
            trLabel.isEnabled = appSettings.trEnabled
            trSelect.isEnabled = appSettings.trEnabled
        case 3:
            appSettings.blEnabled = blButton.state == .on
            blLabel.isEnabled = appSettings.blEnabled
            blSelect.isEnabled = appSettings.blEnabled
        case 4:
            appSettings.brEnabled = brButton.state == .on
            brLabel.isEnabled = appSettings.brEnabled
            brSelect.isEnabled = appSettings.brEnabled
        default:
            break
        }
        StatusBar().update()
    }

    @objc func delayHideSwitch(_ button: NSButton) {
        appSettings.delayHide = button.state == .on
    }

    @objc func hideStatusBarSwitch(_ button: NSButton) {
        appSettings.hideStatusBar = button.state == .on
        StatusBar().hide(status: appSettings.hideStatusBar)
    }

    @objc func startupSwitch(_ button: NSButton) {
        appSettings.startup = button.state == .on
        (NSApp.delegate as? AppDelegate)?.startupCheck()
    }
}

// Delay settings
extension Settings: NSTextFieldDelegate {
    func delaySettings() {
        genericSettings(type: msDelayLabel, status: true,
                        input: NSLocalizedString("detection_delay_label", comment: "")+":")
        msDelayLabel.frame = CGRect(x: 20, y: window!.frame.height-220,
                                    width: msDelayLabel.frame.width, height: msDelayLabel.frame.height)
        msDelayLabel.isBordered = false
        msDelayLabel.isBezeled = false
        msDelayLabel.drawsBackground = false
        msDelayLabel.alignment = .left

        msDelayText.sizeToFit()
        msDelayText.frame = CGRect(x: 20, y: window!.frame.height-240, width: 40, height: msDelayText.frame.height)
        msDelayText.stringValue = String(appSettings.msDelay)
        msDelayText.isEditable = true
        msDelayText.delegate = self
        window?.contentView?.addSubview(msDelayText)

        genericSettings(type: delayHideSetting, status: appSettings.delayHide,
                        input: NSLocalizedString("delay_on_hide", comment: ""), checkbox: true)
        delayHideSetting.frame = CGRect(x: 20, y: window!.frame.height-270,
                                        width: delayHideSetting.frame.width, height: delayHideSetting.frame.height)
        delayHideSetting.action = #selector(delayHideSwitch(_:))
    }

    func controlTextDidChange(_ obj: Notification) {
        if msDelayText.stringValue.count > 4 {
            msDelayText.stringValue = String(appSettings.msDelay)
        }
        if CharacterSet(charactersIn: msDelayText.stringValue).isSubset(of: .decimalDigits) {
            if !msDelayText.stringValue.isEmpty {
                appSettings.msDelay = msDelayText.integerValue
            }
        } else {
            msDelayText.stringValue = String(msDelayText.stringValue.dropLast(1))
        }
    }
}
