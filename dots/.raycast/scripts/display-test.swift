#!/usr/bin/swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Display Test
// @raycast.mode silent

// Optional parameters:
// @raycast.icon 🖥️

// Documentation:
// @raycast.author rsefer
// @raycast.authorURL https://raycast.com/rsefer

import AppKit
import Foundation

struct Layout: Decodable {
	let screens : Any
	let appGroups : Any
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: RootKeys.self)
		screens = try values.decode(Int.self, forKey: .screens)
		appGroups = try values.decode(Int.self, forKey: .appGroups)
	}
}

let runningApplications = NSWorkspace.shared.runningApplications.filter{ $0.activationPolicy == .regular }

let layoutsJSONPath = "\(ProcessInfo.processInfo.environment["DOTFILES_ROOT"] ?? "")/mac-scripts/layouts.json"
var layouts : Any = []

if FileManager.default.fileExists(atPath: layoutsJSONPath) {
	do {
		let data = try Data(contentsOf: URL(fileURLWithPath: layoutsJSONPath))
		layouts = try JSONDecoder().decode(Layout.self, from: data)

	} catch {
		print("Error reading JSON file: \(error)")
	}
}
print(layouts)

// NSScreen.screens.forEach {
// 	print($0.localizedName)
// 	print($0.visibleFrame)
// }
