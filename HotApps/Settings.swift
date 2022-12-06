//
//  Settings.swift
//  HotApps
//
//  Created by SkyrilHD on 29.11.22.
//

import Cocoa

class Settings: NSWindowController, NSWindowDelegate, NSTextFieldDelegate {
    let tlButton = NSButton(checkboxWithTitle: "Enable top-left corner", target: nil, action: nil)
    var tlLabel = NSTextField(string: tlApp)
    let tlSelect = NSButton(title: "Select", target: nil, action: nil)

    let trButton = NSButton(checkboxWithTitle: "Enable top-right corner", target: nil, action: nil)
    var trLabel = NSTextField(string: trApp)
    let trSelect = NSButton(title: "Select", target: nil, action: nil)
    
    let blButton = NSButton(checkboxWithTitle: "Enable bottom-left corner", target: nil, action: nil)
    var blLabel = NSTextField(string: blApp)
    let blSelect = NSButton(title: "Select", target: nil, action: nil)

    let brButton = NSButton(checkboxWithTitle: "Enable bottom-right corner", target: nil, action: nil)
    var brLabel = NSTextField(string: brApp)
    let brSelect = NSButton(title: "Select", target: nil, action: nil)

    var msDelayLabel = NSTextField(string: "Detection delay (in ms):")
    var msDelayText = NSTextField(string: String(msDelay))

    var delayHideSetting = NSButton(checkboxWithTitle: "Apply delay when hiding apps", target: nil, action: nil)

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

        self.window!.setContentSize(NSSize(width: tlSelect.frame.maxX+20, height: self.window!.frame.height-brSelect.frame.minY+60))

        delaySettings()

        appSettings()
        self.window?.center()
    }

    func topLeftSettings() {
        // 'Top-left corner' toggle
        tlButton.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 80)-80, width: brButton.frame.width, height: tlButton.frame.height)
        tlButton.tag = 1
        tlButton.state = tlEnabled ? .on : .off
        tlButton.action = #selector(self.cornerSwitch(_:))
        self.window?.contentView?.addSubview(tlButton)

        // 'Top-left corner' application path label
        genericSettings(type: tlLabel, status: tlEnabled, input: tlApp)
        tlLabel.frame = CGRect(x: tlButton.frame.maxX+50, y: tlButton.frame.maxY-(tlLabel.frame.height), width: largestPath, height: tlLabel.frame.height)
        self.window?.contentView?.addSubview(tlLabel)

        // 'Top-left corner' Select button
        genericSettings(type: tlSelect, status: tlEnabled, input: nil)
        tlSelect.frame = CGRect(x: tlLabel.frame.maxX+50, y: tlLabel.frame.midY-tlSelect.frame.height/2, width: tlSelect.frame.width, height: tlSelect.frame.height)
        tlSelect.tag = 1
        self.window?.contentView?.addSubview(tlSelect)
    }

    func topRightSettings() {
        // 'Top-right corner' toggle
        trButton.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 110)-110, width: brButton.frame.width, height: trButton.frame.height)
        trButton.tag = 2
        trButton.state = trEnabled ? .on : .off
        trButton.action = #selector(self.cornerSwitch(_:))
        self.window?.contentView?.addSubview(trButton)

        // 'Top-right corner' application path label
        genericSettings(type: trLabel, status: trEnabled, input: trApp)
        trLabel.frame = CGRect(x: trButton.frame.maxX+50, y: trButton.frame.maxY-(trLabel.frame.height), width: largestPath, height: trLabel.frame.height)
        trLabel.sizeThatFits(NSSize(width: self.window!.frame.width-trSelect.frame.width-70-trLabel.frame.minX, height: 0))
        self.window?.contentView?.addSubview(trLabel)

        // 'Top-right corner' Select button
        genericSettings(type: trSelect, status: trEnabled, input: nil)
        trSelect.frame = CGRect(x: trLabel.frame.maxX+50, y: trLabel.frame.midY-trSelect.frame.height/2, width: trSelect.frame.width, height: trSelect.frame.height)
        trSelect.tag = 2
        self.window?.contentView?.addSubview(trSelect)
    }

    func bottomLeftSettings() {
        // 'Bottom-left corner' toggle
        blButton.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 140)-140, width: brButton.frame.width, height: blButton.frame.height)
        blButton.tag = 3
        blButton.state = blEnabled ? .on : .off
        blButton.action = #selector(self.cornerSwitch(_:))
        self.window?.contentView?.addSubview(blButton)

        // 'Botton-left corner' application path label
        genericSettings(type: blLabel, status: blEnabled, input: blApp)
        blLabel.frame = CGRect(x: blButton.frame.maxX+50, y: blButton.frame.maxY-(blLabel.frame.height), width: largestPath, height: blLabel.frame.height)
        self.window?.contentView?.addSubview(blLabel)

        // 'Bottom-left corner' Select button
        genericSettings(type: blSelect, status: blEnabled, input: nil)
        blSelect.frame = CGRect(x: blLabel.frame.maxX+50, y: blLabel.frame.midY-blSelect.frame.height/2, width: blSelect.frame.width, height: blSelect.frame.height)
        blSelect.tag = 3
        self.window?.contentView?.addSubview(blSelect)
    }

    func bottomRightSettings() {
        // 'Bottom-right corner' toggle
        brButton.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 170)-170, width: brButton.frame.width, height: brButton.frame.height)
        brButton.tag = 4
        brButton.state = brEnabled ? .on : .off
        brButton.action = #selector(self.cornerSwitch(_:))
        self.window?.contentView?.addSubview(brButton)

        // 'Bottom-right corner' application path label
        genericSettings(type: brLabel, status: brEnabled, input: brApp)
        brLabel.frame = CGRect(x: brButton.frame.maxX+50, y: brButton.frame.maxY-(brLabel.frame.height), width: largestPath, height: brLabel.frame.height)
        self.window?.contentView?.addSubview(brLabel)

        // 'Bottom-right corner' Select button
        genericSettings(type: brSelect, status: brEnabled, input: nil)
        brSelect.frame = CGRect(x: brLabel.frame.maxX+50, y: brLabel.frame.midY-brSelect.frame.height/2, width: brSelect.frame.width, height: brSelect.frame.height)
        brSelect.tag = 4
        self.window?.contentView?.addSubview(brSelect)
    }

    func cleanName(input: String) -> String {
        return input.components(separatedBy: "/").last!
    }

    func getLargestPath() -> CGFloat {
        var largestValue: CGFloat
        largestValue = getStringSize(content: tlLabel.stringValue)
        if (largestValue < getStringSize(content: trLabel.stringValue)) {
            largestValue = getStringSize(content: trLabel.stringValue)
        }
        if (largestValue < getStringSize(content: blLabel.stringValue)) {
            largestValue = getStringSize(content: blLabel.stringValue)
        }
        if (largestValue < getStringSize(content: brLabel.stringValue)) {
            largestValue = getStringSize(content: brLabel.stringValue)
        }
        return largestValue+20
    }

    func getStringSize(content: String) -> CGFloat {
        return content.size().width
    }

    func appSettings() {
        largestPath = getLargestPath()
        topLeftSettings()
        topRightSettings()
        bottomLeftSettings()
        bottomRightSettings()
    }

    func delaySettings() {
        msDelayLabel.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 220)-220, width: msDelayLabel.frame.width, height: msDelayLabel.frame.height)
        msDelayLabel.isEditable = false
        msDelayLabel.isSelectable = false
        msDelayLabel.isBordered = false
        msDelayLabel.isBezeled = false
        msDelayLabel.drawsBackground = false
        self.window?.contentView?.addSubview(msDelayLabel)
        
        msDelayText.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 240)-240, width: 40, height: msDelayText.frame.height)
        msDelayText.stringValue = String(msDelay)
        msDelayText.isEditable = true
        msDelayText.delegate = self
        self.window?.contentView?.addSubview(msDelayText)

        delayHideSetting.frame = CGRect(x: ((self.window?.frame.width)!)-delayHideSetting.frame.width-20, y: (self.window?.frame.height ?? 220)-220, width: delayHideSetting.frame.width, height: delayHideSetting.frame.height)
        delayHideSetting.state = delayHide ? .on : .off
        delayHideSetting.action = #selector(self.delayHideSwitch(_:))
        self.window?.contentView?.addSubview(delayHideSetting)
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
            textField.alignment = NSTextAlignment.center
            textField.font = NSFont(name: ".AppleSystemUIFont", size: 13)
        } else if type.isKind(of: NSButton.self) {
            let button: NSButton = type as! NSButton
            button.setButtonType(.momentaryPushIn)
            button.target = self
            button.isEnabled = status
            button.action = #selector(self.openDocument(_:))
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
            self.window!.setContentSize(NSSize(width: tlSelect.frame.maxX+20, height: self.window!.frame.height-brSelect.frame.minY+60))
            delaySettings()
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
}
