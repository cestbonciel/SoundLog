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
//	let tableView = UITableView(frame: .zero, style: .plain)
	
	private lazy var settingIcon: UIButton = {
		let button = UIButton()
		button.tintColor = .label
		let imageSize = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
		let image = UIImage(systemName: "gearshape.fill", withConfiguration: imageSize)
		button.setImage(image, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	private let introLabel: UILabel = {
		let label = UILabel()
		label.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
		label.text = "당신을 위한,소리의 기록"
		label.textColor = .systemDimGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
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
//		 tableView.backgroundColor = .clear
		
    }
	private func settingViewUI() {
		
		view.addSubview(settingIcon)
		view.addSubview(introLabel)
		
		settingIcon.snp.makeConstraints {
			$0.top.equalTo(view.snp.top).inset(56)
			$0.trailing.equalTo(view.snp.trailing).inset(32)
		}
		
		introLabel.snp.makeConstraints {
			$0.top.equalToSuperview().offset(120)
			$0.left.equalToSuperview().inset(32)
		}
		
		
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

