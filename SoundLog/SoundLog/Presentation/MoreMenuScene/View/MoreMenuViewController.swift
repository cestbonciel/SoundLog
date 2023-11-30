//
//  MoreMenuViewController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/28.
//

import UIKit
import SnapKit

class MoreMenuViewController: UIViewController {
    
    lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.barTintColor = .pastelSkyblue
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //      settingViewUI()
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        view.addSubview(navigationBar)
        
        navigationBar.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        navigationBar.backgroundColor = .pastelSkyblue
        navigationBar.tintColor = .label
        view.backgroundColor = .pastelSkyblue
        let navItem = UINavigationItem()
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(moveToSettingView))
        navItem.rightBarButtonItem = rightButton
        navigationBar.setItems([navItem], animated: true)
    }
    
    
   @objc func moveToSettingView(_ sender: UIBarButtonItem) {
        let settingViewController = SettingViewController()
        settingViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
    private func setupNavigationBar() {
        let settingConfig = CustomNaviBarItemConfiguration(image: UIImage(systemName: "gearshape.fill")) {
            let settingViewController = SettingViewController()
            settingViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(settingViewController, animated: true)
        }
        
        let settingItem = UIBarButtonItem.make(with: settingConfig, width: 24)
        
        navigationItem.rightBarButtonItem = settingItem
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .black
    }

    
}


//MARK: - Preview Setting
//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//struct SettingViewControllerRepresentable: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> some UIViewController {
//        return UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "MoreMenus")
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//
//    }
//}
//
//struct SettingViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        SettingViewControllerRepresentable()
//    }
//}
//#endif
//
