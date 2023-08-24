//
//  GenreTableViewController.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/08/24.
//

import UIKit

class GenreTableViewController: UITableViewController {
	var genreVC: RecordMusicDiaryViewController?
	var hierachicalData = ["Jazz", "POP", "K-POP", "Classic", "ASMR", "EDM"]
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return hierachicalData.count
	}

	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath)
		
		cell.textLabel?.text = hierachicalData[indexPath.row]
		 

		return cell
	}
}
