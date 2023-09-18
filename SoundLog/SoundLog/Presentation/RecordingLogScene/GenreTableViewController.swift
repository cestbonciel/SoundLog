//
//  GenreTableViewController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/24.
//

import UIKit

class GenreTableViewController: UITableViewController {
	var genreVC: RecordingSoundLogViewController?
	var hierachicalData = ["Jazz", "POP", "K-POP", "Classic", "ASMR", "EDM"]
	
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
