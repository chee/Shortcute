//
//  ShortcuteTableViewController.swift
//  Shortcute
//
//  Created by chee on 09/10/2018.
//  Copyright © 2018 snoots & co. All rights reserved.
//

import UIKit
import os.log

class ShortcuteTableViewController: UITableViewController {
	
	var shortcutes = [Shortcute]()

    override func viewDidLoad() {
        super.viewDidLoad()

		if let saved = load() {
			shortcutes += saved
		} else {
			loadSampleShortcutes()
		}

        // self.clearsSelectionOnViewWillAppear = false
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shortcutes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let identifier = "ShortcuteViewCell"
		
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: identifier,
			for: indexPath
		) as? ShortcuteTableViewCell else {
				fatalError("oh no it isn't a shortcute cell bb")
		}
		
		let shortcute = shortcutes[indexPath.row]
		
		print(shortcute.name)
		
		cell.nameLabel.text = shortcute.name
		cell.shortcuteLabel.text = shortcute.shortcutName
		cell.inputLabel.text = shortcute.input
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		cell.timeLabel.text = dateFormatter.string(from: shortcute.time)
		
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			shortcutes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
		
		save()
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		
		switch (segue.identifier ?? "") {
		case "AddItem":
			os_log("Adding a new meal", log: OSLog.default, type: .debug)
		case "ShowDetail":
			guard let detailViewController = segue.destination as? ShortcuteDetailViewController else {
				fatalError("unexpected destination: \(segue.destination)")
			}
			
			guard let shortcuteCell = sender as? ShortcuteTableViewCell else {
				fatalError("unexpected sender: \(String(describing: sender))")
			}
			
			guard let indexPath = tableView.indexPath(for: shortcuteCell) else {
				fatalError("we ain't got that cell in the list?")
			}
			
			let shortcute = shortcutes[indexPath.row]
			
			detailViewController.shortcute = shortcute
		default:
			fatalError("what have you done? this is not a segue we want: \(String(describing: segue.identifier))")
		}
    }
	
	@IBAction func unwindToList(sender: UIStoryboardSegue) {
		if let source = sender.source as? ShortcuteDetailViewController, let shortcute = source.shortcute {
			if let currentPath = tableView.indexPathForSelectedRow {
				shortcutes[currentPath.row] = shortcute
				tableView.reloadRows(at: [currentPath], with: .automatic)
			} else {
				let indexPath = IndexPath(
					row: shortcutes.count,
					section: 0
				)
				
				shortcutes.append(shortcute)
				
				tableView.insertRows(at: [indexPath], with: .automatic)
			}
			save()
		}
	}
	
	private func save() {
		Shortcute.saveAllToDisk(shortcutes)
	}
	
	private func load() -> [Shortcute]? {
		return Shortcute.loadAllFromDisk()
	}

	private func loadSampleShortcutes() {
		guard let first = Shortcute(
			name: "love abe at 6am",
			shortcutName: "text abe",
			input: "i love you",
			time: Date(timeIntervalSince1970: 60 * 60 * 6)
		) else {
			fatalError("oh no i couldn't do it to first shortcute")
		}
		
		guard let second = Shortcute(
			name: "love abe at 12am",
			shortcutName: "text abe",
			input: "i love you",
			time: Date(timeIntervalSince1970: 1)
		) else {
				fatalError("oh no i couldn't do it to second shortcute")
		}
		
		guard let third = Shortcute(
			name: "love abe at 2am",
			shortcutName: "text abe",
			input: "i love you",
			time: Date(timeIntervalSince1970: 60 * 60 * 2)
		) else {
				fatalError("oh no i couldn't do it to third shortcute")
		}
		
		shortcutes += [
			first,
			second,
			third
		]
	}
	
}
