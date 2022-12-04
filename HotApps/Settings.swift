//
//  Settings.swift
//  HotApps
//
//  Created by SkyrilHD on 29.11.22.
//

import Cocoa

class Settings: NSWindowController, NSWindowDelegate {
    // TODO: Implement action for checkbox buttons
    
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

        self.window?.level = NSWindow.Level.normal
        self.window?.title = "HotApps Settings"

        self.window?.delegate = self

        appSettings()

        self.window!.setContentSize(NSSize(width: tlSelect.frame.maxX+20, height: self.window!.frame.height-brSelect.frame.minY))

        appSettings()
        self.window?.center()
    }

    func topLeftSettings() {
        // 'Top-left corner' toggle
        tlButton.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 80)-80, width: brButton.frame.width, height: tlButton.frame.height)
        tlButton.state = .on
        self.window?.contentView?.addSubview(tlButton)

        // 'Top-left corner' application path label
        tlLabel.stringValue = self.cleanName(input: tlLabel.stringValue)
        tlLabel.isEditable = false
        tlLabel.isSelectable = true
        tlLabel.alignment = NSTextAlignment.center
        tlLabel.font = NSFont.userFont(ofSize: 12)
        tlLabel.frame = CGRect(x: tlButton.frame.maxX+50, y: tlButton.frame.maxY-(tlLabel.frame.height), width: largestPath, height: tlLabel.frame.height)
        self.window?.contentView?.addSubview(tlLabel)

        // 'Top-left corner' Select button
        tlSelect.setButtonType(.momentaryPushIn)
        tlSelect.target = self
        tlSelect.action = #selector(self.openDocument(_:))
        tlSelect.frame = CGRect(x: tlLabel.frame.maxX+50, y: tlLabel.frame.midY-tlSelect.frame.height/2, width: tlSelect.frame.width, height: tlSelect.frame.height)
        tlSelect.tag = 1
        self.window?.contentView?.addSubview(tlSelect)
    }

    func topRightSettings() {
        // 'Top-right corner' toggle
        trButton.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 110)-110, width: brButton.frame.width, height: trButton.frame.height)
        trButton.state = .on
        self.window?.contentView?.addSubview(trButton)

        // 'Top-right corner' application path label
        trLabel.stringValue = self.cleanName(input: trLabel.stringValue)
        trLabel.isEditable = false
        trLabel.isSelectable = false
        trLabel.alignment = NSTextAlignment.center
        trLabel.font = NSFont.userFont(ofSize: 12)
        trLabel.frame = CGRect(x: trButton.frame.maxX+50, y: trButton.frame.maxY-(trLabel.frame.height), width: largestPath, height: trLabel.frame.height)
        trLabel.sizeThatFits(NSSize(width: self.window!.frame.width-trSelect.frame.width-70-trLabel.frame.minX, height: 0))
        self.window?.contentView?.addSubview(trLabel)

        // 'Top-right corner' Select button
        trSelect.setButtonType(.momentaryPushIn)
        trSelect.target = self
        trSelect.action = #selector(self.openDocument(_:))
        trSelect.frame = CGRect(x: trLabel.frame.maxX+50, y: trLabel.frame.midY-trSelect.frame.height/2, width: trSelect.frame.width, height: trSelect.frame.height)
        trSelect.tag = 2
        self.window?.contentView?.addSubview(trSelect)
    }

    func bottomLeftSettings() {
        // 'Bottom-left corner' toggle
        blButton.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 140)-140, width: brButton.frame.width, height: blButton.frame.height)
        blButton.state = .on
        self.window?.contentView?.addSubview(blButton)

        // 'Botton-left corner' application path label
        blLabel.stringValue = self.cleanName(input: blLabel.stringValue)
        blLabel.isEditable = false
        blLabel.isSelectable = false
        blLabel.alignment = NSTextAlignment.center
        blLabel.font = NSFont.userFont(ofSize: 12)
        blLabel.frame = CGRect(x: blButton.frame.maxX+50, y: blButton.frame.maxY-(blLabel.frame.height), width: largestPath, height: blLabel.frame.height)
        self.window?.contentView?.addSubview(blLabel)

        // 'Bottom-left corner' Select button
        blSelect.setButtonType(.momentaryPushIn)
        blSelect.target = self
        blSelect.action = #selector(self.openDocument(_:))
        blSelect.frame = CGRect(x: blLabel.frame.maxX+50, y: blLabel.frame.midY-blSelect.frame.height/2, width: blSelect.frame.width, height: blSelect.frame.height)
        blSelect.tag = 3
        self.window?.contentView?.addSubview(blSelect)
    }

    func bottomRightSettings() {
        // 'Bottom-right corner' toggle
        brButton.frame = CGRect(x: 20, y: (self.window?.frame.height ?? 170)-170, width: brButton.frame.width, height: brButton.frame.height)
        brButton.state = .on
        self.window?.contentView?.addSubview(brButton)

        // 'Bottom-right corner' application path label
        brLabel.stringValue = self.cleanName(input: brLabel.stringValue)
        brLabel.isEditable = false
        brLabel.isSelectable = false
        brLabel.alignment = NSTextAlignment.center
        brLabel.font = NSFont.userFont(ofSize: 12)
        brLabel.frame = CGRect(x: brButton.frame.maxX+50, y: brButton.frame.maxY-(brLabel.frame.height), width: largestPath, height: brLabel.frame.height)
        self.window?.contentView?.addSubview(brLabel)

        // 'Bottom-right corner' Select button
        brSelect.setButtonType(.momentaryPushIn)
        brSelect.target = self
        brSelect.action = #selector(self.openDocument(_:))
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
            self.window!.setContentSize(NSSize(width: tlSelect.frame.maxX+20, height: self.window!.frame.height-brSelect.frame.minY))
            StatusBar().update()
        }
    }
}
