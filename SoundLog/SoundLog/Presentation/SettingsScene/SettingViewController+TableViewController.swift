//
//  SettingViewController+TableViewController.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/09/03.
//

import UIKit

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0  {
			return settingMenus.count
		} else {
			return policyMenus.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: SettingMenuCell.identifier, for: indexPath) as! SettingMenuCell
//		cell.selectionStyle = .none
		
		if indexPath.section == 0 {
			let settingIcon = self.settingIcons[indexPath.row]
			let menus = settingMenus[indexPath.row]
			cell.configure(with: settingIcon, and: menus)
			cell.accessoryType = .disclosureIndicator
		} else {
//			var contentConfiguration = cell.defaultContentConfiguration()
//			contentConfiguration.text = policyMenus[indexPath.row]
//			cell.contentConfiguration = contentConfiguration
			let policyTitle = self.policyMenus[indexPath.row]
			cell.defaultConfigure(label: policyTitle)
			cell.accessoryType = .checkmark
		}

		return cell
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//		tableView.deselectRow(at: indexPath, animated: true)
		if indexPath.section == 0 {
			let settingMenus = settingMenus[indexPath.row]
			
			
			switch settingMenus {
			case "북마크한 기록":
				if let bookmarkVC = self.storyboard?.instantiateViewController(withIdentifier: "BookmarkViewController"){
		
					showDetailViewController(bookmarkVC, sender: nil)
	//				self.navigationController?.pushViewController(bookmarkVC, animated: true)
				}

			case "테마변경":
				
				if let themeVC = self.storyboard?.instantiateViewController(identifier: "ThemeViewController") {
					let navigationController = UINavigationController(rootViewController: themeVC)
		
					// 내비게이션 컨트롤러를 present
					 
					self.present(navigationController, animated: true)
	//				self.navigationItem.backButtonTitle = "Back"
					self.navigationItem.backButtonDisplayMode = .minimal
					self.navigationController?.navigationBar.tintColor = .black
					self.navigationController?.navigationBar.topItem?.title = "Back"
	//				themeVC.modalPresentationStyle = .overFullScreen
	//				self.present(themeVC, animated: true)
	//				self.navigationController?.pushViewController(themeVC, animated: true)
				}
			case "언어변경":
				
				if let langVC = self.storyboard?.instantiateViewController(identifier: "LanguageViewController") {
					showDetailViewController(langVC, sender: nil)
				}
	//		case "제안하기 / 문의하기":
	//			if let inquiryVC = self.
			default:
				return
			}
		} else {
			
			if indexPath.row == 0 {
				let viewController = InquiryViewController()
				navigationItem.backButtonDisplayMode = .minimal
				self.navigationController?.pushViewController(viewController, animated: true)
			} else if indexPath.row == 1 {
				let vc = TermOfUseController()
				navigationItem.backButtonDisplayMode = .minimal
				self.navigationController?.pushViewController(vc, animated: true)
				
			}
		}
		
		
	}
	
	
}

