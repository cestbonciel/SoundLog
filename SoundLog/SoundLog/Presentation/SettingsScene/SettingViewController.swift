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
		label.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
		label.text = "당신을 위한 소리 기록장"
		label.textColor = .systemDimGray
		return label
	}()

	private let profileImage: UIImageView = {
		let imageView = UIImageView(frame: CGRect(x: 30, y: 122, width: 56, height: 56))
		let profileImage: UIImage = UIImage(named: "profileIcon")!
		imageView.image = profileImage
		return imageView
	}()
	private let profileNameLabel: UILabel = {
		let nickNamelabel = UILabel()
		nickNamelabel.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
		nickNamelabel.text = "뮤덕이"
		nickNamelabel.textColor = .black
		return nickNamelabel
	}()

	
    override func viewDidLoad() {
        super.viewDidLoad()
		settingViewUI()
		
		
    }
	private func settingViewUI() {
		
		
		self.view.addSubview(introLabel)
		//introLabel.setContentCompressionResistancePriority(.init(rawValue:231), for: .horizontal)
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
			$0.left.right.bottom.equalToSuperview().inset(10)

		}
		tableView.register(SettingMenuCell.self, forCellReuseIdentifier: SettingMenuCell.identifier)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
//		tableView.estimatedRowHeight = 77
		tableView.isScrollEnabled = false
		
	}
	
	
}

//MARK: - Preview Setting
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct SettingViewControllerRepresentable: UIViewControllerRepresentable {
	func makeUIViewController(context: Context) -> some UIViewController {
		return UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "SettingMenus")
	}
	
	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
		
	}
}

struct SettingViewController_Preview: PreviewProvider {
	static var previews: some View {
		SettingViewControllerRepresentable()
	}
}
#endif

