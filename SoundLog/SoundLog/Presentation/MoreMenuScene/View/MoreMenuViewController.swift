//
//  MoreMenuViewController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/28.
//

import UIKit
import SnapKit

class MoreMenuViewController: UIViewController {
   
   /// TableView Setting Menu
   	let tableView = UITableView(frame: .zero, style: .plain)
   
   private lazy var settingIcon: UIButton = {
      let button = UIButton()
      button.tintColor = .label
      let imageSize = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
      let image = UIImage(systemName: "gearshape.fill", withConfiguration: imageSize)
      button.setImage(image, for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
   }()
   
//   private let introLabel: UILabel = {
//      let label = UILabel()
//      label.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
//      label.text = "당신을 위한,소리의 기록"
//      label.textColor = .systemDimGray
//      label.translatesAutoresizingMaskIntoConstraints = false
//      return label
//   }()
   
   
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
      
      view.addSubview(settingIcon)
      
      
      settingIcon.snp.makeConstraints {
         $0.top.equalTo(view.snp.top).inset(56)
         $0.trailing.equalTo(view.snp.trailing).inset(32)
      }
     
   }
}

//MARK: - Extension: TableView
extension MoreMenuViewController: UITableViewDelegate, UITableViewDataSource {
   
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 3
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "MoreMenuTableViewCell", for: indexPath)
      cell.selectionStyle = .none
      
      return cell
   }
   
   
   
}

//MARK: - Preview Setting
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct SettingViewControllerRepresentable: UIViewControllerRepresentable {
   func makeUIViewController(context: Context) -> some UIViewController {
      return UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "MoreMenus")
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

