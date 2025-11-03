import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var timer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem?.button {
            button.title = "1"
            button.font = NSFont.systemFont(ofSize: 12, weight: .semibold)
        }

        // Create menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit RustySpaces", action: #selector(quitApp), keyEquivalent: "q"))
        statusItem?.menu = menu

        // Start monitoring spaces
        startSpaceMonitoring()
    }

    func startSpaceMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.updateCurrentSpace()
        }
    }

    func updateCurrentSpace() {
        let currentSpace = getCurrentSpace()
        if let button = statusItem?.button {
            button.title = "\(currentSpace)"
        }
    }

    func getCurrentSpace() -> Int {
        // Try yabai first (most reliable)
        if let spaceFromYabai = getSpaceFromYabai() {
            return spaceFromYabai
        }

        // Fallback to AppleScript
        return getSpaceFromAppleScript()
    }

    func getSpaceFromYabai() -> Int? {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "yabai -m query --spaces --display | jq '.[] | select(.\"is-visible\" == true) | .index'"]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = Pipe()

        do {
            try task.run()
            task.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
               !output.isEmpty,
               let spaceNumber = Int(output) {
                return spaceNumber
            }
        } catch {
            // Silently fail, will use AppleScript fallback
        }

        return nil
    }

    func getSpaceFromAppleScript() -> Int {
        let script = """
        tell application "System Events"
            set visibleSpace to 0
            set desktopSpaces to spaces of desktop 1
            repeat with spaceIndex from 1 to count of desktopSpaces
                set theSpace to item spaceIndex of desktopSpaces
                if visible of theSpace then
                    set visibleSpace to spaceIndex
                end if
            end repeat
            return visibleSpace
        end tell
        """

        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e", script]

        let pipe = Pipe()
        task.standardOutput = pipe
        let errorPipe = Pipe()
        task.standardError = errorPipe

        do {
            try task.run()
            task.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
               !output.isEmpty,
               let spaceNumber = Int(output) {
                return spaceNumber
            }
        } catch {
            // Silently fail
        }

        return 1
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

@main
struct RustySpaces {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}
