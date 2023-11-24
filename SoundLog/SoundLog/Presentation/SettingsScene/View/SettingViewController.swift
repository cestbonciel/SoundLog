//
//  SettingViewController.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/08/28.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController{
	

	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

//MARK: - Extension: TableView
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
    cell.selectionStyle = .none
   
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

