//
//  ViewController.swift
//  TableViewDeleteTests
//
//  Created by Dylan Lewis on 05/09/2018.
//  Copyright © 2018 ASOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	var numberOfItems = 5
	@IBOutlet var tableView: UITableView!

	func removeCell(at indexPath: IndexPath) {
		numberOfItems -= 1

		tableView.performBatchUpdates({
			self.tableView.deleteRows(at: [indexPath], with: .none)
		}, completion: nil)
	}

	func addCellAndMoveRows() {
		let indexPath = IndexPath(row: numberOfItems, section: 0)
		numberOfItems += 1

		tableView.performBatchUpdates({
			self.tableView.insertRows(at: [indexPath], with: .none)

			// !!! Crashes here !!!
			let allIndexPaths = (0..<numberOfItems-1).map({ IndexPath(row: $0, section: 0) })
			for indexPath in allIndexPaths {
				tableView.moveRow(at: indexPath, to: indexPath)
			}
		}, completion: nil)
	}
}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return numberOfItems
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "helloWorld")!
		return cell
	}
}

extension ViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let removeAndAdd = UITableViewRowAction(
			style: .destructive, title: "bye bye", handler: { (_, indexPath) in
				self.removeCell(at: indexPath)
				DispatchQueue.main.async(execute: {
					self.addCellAndMoveRows()
				})
			}
		)
		return [removeAndAdd]
	}
}
