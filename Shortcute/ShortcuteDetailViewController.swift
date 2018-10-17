//
//Users/chee/projects/Shortcute/Shortcute/ShortcuteDetailViewController.swift/  ViewController.swift
//  Shortcute
//
//  Created by chee on 07/10/2018.
//  Copyright © 2018 snoots & co. All rights reserved.
//

import UIKit
import os.log

class ShortcuteDetailViewController: UIViewController, UITextFieldDelegate {
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var shortcutInputField: UITextField!
	@IBOutlet weak var shortcutField: UITextField!
	@IBOutlet weak var typePicker: UISegmentedControl!
	@IBOutlet weak var timePicker: UIDatePicker!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	var shortcute: Shortcute?
	
	@IBAction func segmentChanged(_ sender: UISegmentedControl, forEvent event: UIEvent) {
	}
	
	@IBAction func timeChanged(_ sender: UIDatePicker, forEvent event: UIEvent) {
		print(sender.date)
	}
	
	@IBAction func gogogo(_ sender: Any) {
		if let shortcute = shortcute {
			shortcute.open()
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		updateSaveButtonState()
		print(textField)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		
		guard let button = sender as? UIBarButtonItem, button === saveButton else {
			os_log("oh no we didnt a save button pressed??", log: OSLog.default, type: .debug)
			return
		}
		
		let name = nameField.text ?? ""
		let shortcutName = shortcutField.text ?? ""
		let input = shortcutInputField.text ?? ""
		let time = timePicker.date
		
		shortcute = Shortcute(
			name: name,
			shortcutName: shortcutName,
			input: input,
			time: time
		)
	}

	override func viewDidLoad() {
        super.viewDidLoad()
		
		if let shortcute = shortcute {
			navigationItem.title = shortcute.name
			nameField.text = shortcute.name
			shortcutField.text = shortcute.shortcutName
			shortcutInputField.text = shortcute.input
			timePicker.date = shortcute.time
			nameField.clearsOnInsertion = false
		}
		
		nameField.delegate = self
		shortcutField.delegate = self
		shortcutInputField.delegate = self
		
		updateSaveButtonState()
    }
	
	func ifnʹt (_ condition: Bool, block: () -> Void) {
		if (!condition) {
			block()
		}
	}
	
	private func updateSaveButtonState() {
		let text = nameField.text ?? ""

		ifnʹt (text.isEmpty) {
			navigationItem.title = nameField.text
		}
		
		saveButton.isEnabled = !text.isEmpty
	}
}

