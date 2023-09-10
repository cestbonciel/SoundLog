//
//  SettingViewController+TableViewController.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/09/03.
//

import UIKit

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return settingMenus.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: SettingMenuCell.identifier, for: indexPath) as! SettingMenuCell
		let menus = settingMenus[indexPath.row]
		cell.accessoryType = .disclosureIndicator
		let settingIcon = self.settingIcons[indexPath.row]
		
		cell.configure(with: settingIcon, and: menus)

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
		case "언어변경":
			if let themeVC = self.storyboard?.instantiateViewController(identifier: "LanguageViewController") {
				self.navigationController?.pushViewController(themeVC, animated: true)
			}
		default:
			break
		}
	}
}

