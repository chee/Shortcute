//
//  Shortcute.swift
//  Shortcute
//
//  Created by chee on 08/10/2018.
//  Copyright © 2018 snoots & co. All rights reserved.
//

import UIKit
import os.log

class Shortcute: NSObject, NSCoding {
	struct PropertyKey {
		static let name = "name"
		static let shortcutName = "shortcutName"
		static let input = "input"
		static let time = "time"
	}
	
	let app = UIApplication.shared
	let sinceEpoch = Date.timeIntervalSinceReferenceDate + Date.timeIntervalBetween1970AndReferenceDate
	
	var name: String
	var shortcutName: String
	var input: String
	var time: Date
	
	static let DocumentsDirectory = FileManager().urls(
		for: .documentDirectory,
		in: .userDomainMask
	).first!

	static let ArchiveUrl = DocumentsDirectory.appendingPathComponent("shortcutes")
	
	static func saveAllToDisk (_ shortcutes: [Shortcute]) {
		if let archive = try? NSKeyedArchiver.archivedData(withRootObject: shortcutes, requiringSecureCoding: false) {
			do {
				try archive.write(to: Shortcute.ArchiveUrl)
				os_log("yeah it did save", log: .default, type: .debug)
			} catch {
				os_log("yeah it didn't save", log: .default, type: .debug)
			}
		}
	}

	static func loadAllFromDisk () -> [Shortcute]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Shortcute.ArchiveUrl.path) as? [Shortcute]
	}
	
	init?(name: String, shortcutName: String, input: String, time: Date) {
		let isBad = name.isEmpty ||
			shortcutName.isEmpty ||
			input.isEmpty ||
			time.timeIntervalSince1970 == 0
	
		if isBad {
			return nil
		}
		
		self.name = name
		self.shortcutName = shortcutName
		self.input = input
		self.time = time
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(name, forKey: PropertyKey.name)
		aCoder.encode(shortcutName, forKey: PropertyKey.shortcutName)
		aCoder.encode(input, forKey: PropertyKey.input)
		aCoder.encode(time, forKey: PropertyKey.time)
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
		else {
			os_log("failed to get name :(", log: .default, type: .debug)
			return nil
		}
		
		guard let shortcutName = aDecoder.decodeObject(forKey: PropertyKey.shortcutName) as? String
			else {
				os_log("failed to get shortcut name :(", log: .default, type: .debug)
				return nil
		}
		
		guard let input = aDecoder.decodeObject(forKey: PropertyKey.input) as? String
			else {
				os_log("failed to get input :(", log: .default, type: .debug)
				return nil
		}
		
		guard let time = aDecoder.decodeObject(forKey: PropertyKey.time) as? Date
			else {
				os_log("failed to get time :(", log: .default, type: .debug)
				return nil
		}
		
		self.init(
			name: name,
			shortcutName: shortcutName,
			input: input,
			time: time
		)
	}
	
	func toUrl() -> URL? {
		let encodedShortcutName = shortcutName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
		let encodedInput = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

		if (encodedShortcutName.isEmpty || encodedInput.isEmpty) {
			os_log("couldnt make a url", log: .default, type: .debug)
			return nil
		}
		
		let url = URL.init(
			string: "shortcuts://run-shortcut?input=text&name=\(encodedShortcutName)&text=\(encodedInput)"
		)
		
		return url
	}
	
	func open() {
		if let url = toUrl() {
			print("yeah")
			print(url)
			app.open(url)
		}
	}
}
