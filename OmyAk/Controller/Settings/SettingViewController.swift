//
//  SettingViewController.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/08/28.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	let settingMenus = ["북마크한 기록", "테마변경", "언어변경"]
	
	
	let settingTableView: UITableView = {
		
		let tableView = UITableView()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.separatorStyle = .none
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 77
		
		return tableView
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let tableView = UITableView(frame: view.bounds, style: .plain)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		view.addSubview(tableView)
    }
	private func settingViewUI() {
		view.addSubview(settingTableView)
		
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return settingMenus.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = settingMenus[indexPath.row]
		cell.accessoryType = .disclosureIndicator
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let settingMenus = settingMenus[indexPath.row]
		switch settingMenus {
		case "북마크한 기록":
			if let bookmarkVC = self.storyboard?.instantiateViewController(identifier: "BookmarkViewController") {
				self.navigationController?.pushViewController(bookmarkVC, animated: true)
			}
		case "테마변경":
			if let themeVC = self.storyboard?.instantiateViewController(identifier: "ThemeViewController") {
				self.navigationController?.pushViewController(themeVC, animated: true)
			}
		case "언어변경"://LanguageViewController
			if let themeVC = self.storyboard?.instantiateViewController(identifier: "LanguageViewController") {
				self.navigationController?.pushViewController(themeVC, animated: true)
			}
		default:
			break
		}
	}

}

