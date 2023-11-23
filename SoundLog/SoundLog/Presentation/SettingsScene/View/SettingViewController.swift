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
  let userTitleArray: [String] = ["당신을 위한, 소리의 기록", "뮤덕이 님의 소리 저장소", "북마크"]
	private lazy var settingIcon: UIButton = {
		let button = UIButton()
		button.tintColor = .label
		let imageSize = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
		let image = UIImage(systemName: "gearshape.fill", withConfiguration: imageSize)
		button.setImage(image, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
//	private let introLabel: UILabel = {
//		let label = UILabel()
//		label.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
//		label.text = "당신을 위한,소리의 기록"
//		label.textColor = .systemDimGray
//		label.translatesAutoresizingMaskIntoConstraints = false
//		return label
//	}()

	
	private let profileNameLabel: UILabel = {
		let nickNamelabel = UILabel()
		nickNamelabel.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
		nickNamelabel.text = "뮤덕이"
		nickNamelabel.textColor = .black

		return nickNamelabel
	}()
  
  private lazy var modifiedButton: UIButton = {
    let button = UIButton()
    button.frame = CGRect(x: 0, y: 0, width: 48, height: 24)
    button.layer.cornerRadius = 8
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = UIColor.systemGray2
    button.titleLabel?.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
    button.setTitle("취소", for: .normal)
    
//    button.addTarget(self, action: #selector(actCancelButton), for: .touchUpInside)
    return button
  }()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		settingViewUI()
//		 tableView.backgroundColor = .clear
		
    }
	private func settingViewUI() {
		
		view.addSubview(settingIcon)
//		view.addSubview(introLabel)
    view.addSubview(tableView)
    
		settingIcon.snp.makeConstraints {
			$0.top.equalTo(view.snp.top).inset(56)
			$0.trailing.equalTo(view.snp.trailing).inset(32)
		}
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.isScrollEnabled = false
    tableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(100)
      $0.left.right.bottom.equalToSuperview()
    }
		
	}
}

//MARK: - Extension: TableView
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userTitleArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
    cell.selectionStyle = .none
    var contentConfiguration = cell.defaultContentConfiguration()
    contentConfiguration.text = userTitleArray[indexPath.row]
    cell.contentConfiguration = contentConfiguration
    switch indexPath.row {
    case 0:
      cell.textLabel?.text = userTitleArray[0]
    case 1:
      cell.textLabel?.text = userTitleArray[1]
      
    case 2:
    default:
      ()
    }
    return cell
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

