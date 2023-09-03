//
//  SettingViewController.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/08/28.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController{
	
	/// TableView Setting Menu
	let tableView = UITableView(frame: .zero, style: .plain)
	
	let settingMenus: [String] = ["북마크한 기록", "테마변경", "언어변경"]
	let settingIcons: [UIImage] = [
		UIImage(named: "bookmarkIcon")!,
		UIImage(named: "themeIcon")!,
		UIImage(named: "languageIcon")!,
	]

	private let introLabel: UILabel = {
		let label = UILabel()
		label.attributedText = .attributeFont(font: .GMSansMedium, size: 12, text: "당신을 위한 음악 기록, 오늘의 내 음악", lineHeight: 12)
		label.textColor = .systemDimGray
		return label
	}()
	lazy var profileView: UIView = {
		let view = UIView()
		view.backgroundColor = .neonYellow
		view.layer.borderWidth = 1
		view.layer.borderColor = UIColor.green.cgColor
		return view
	}()
	private let profileImage: UIImageView = {
		let imageView = UIImageView(frame: CGRect(x: 30, y: 122, width: 56, height: 56))
		let profileImage: UIImage = UIImage(named: "profileIcon")!
		imageView.image = profileImage
		return imageView
	}()
	private let profileNameLabel: UILabel = {
		let nickNamelabel = UILabel()
		nickNamelabel.attributedText = .attributeFont(font: .GMSansMedium, size: 16, text: "뮤덕이", lineHeight: 16)
		nickNamelabel.textColor = .black
		return nickNamelabel
	}()

	
    override func viewDidLoad() {
        super.viewDidLoad()
		settingViewUI()
		
		
    }
	private func settingViewUI() {
		
		
		self.view.addSubview(introLabel)
		introLabel.setContentCompressionResistancePriority(.init(rawValue:231), for: .horizontal)
		introLabel.snp.makeConstraints {
			$0.top.equalToSuperview().offset(80)
			$0.left.right.equalToSuperview().offset(30)
		}
		
		self.view.addSubview(profileImage)
		profileImage.snp.makeConstraints {
			$0.top.equalTo(introLabel.snp.bottom).inset(-24)
			$0.left.equalToSuperview().offset(30)
		}
		self.view.addSubview(profileNameLabel)
		profileNameLabel.snp.makeConstraints {
			$0.top.equalTo(introLabel.snp.bottom).inset(-48)
			$0.left.equalTo(profileImage.snp.right).inset(-20)
		}
		
		self.view.addSubview(tableView)
		
		tableView.snp.makeConstraints {
			$0.top.equalTo(profileImage.snp.bottom).offset(32)
			$0.left.right.bottom.equalToSuperview()
			$0.left.equalToSuperview().inset(30)
		}
		tableView.register(SettingMenuCell.self, forCellReuseIdentifier: SettingMenuCell.identifier)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.estimatedRowHeight = 77
		tableView.isScrollEnabled = false
		
	}
	
	
}


