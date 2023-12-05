//
//  MoreMenuViewController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/28.
//

import UIKit
import SnapKit

class MoreMenuViewController: UIViewController {
    
    lazy var moreMenuView = MoreMenuView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 네비게이션 바 생성
//        let navigationBar = UINavigationBar()
//        navigationBar.barTintColor = .pastelSkyblue
//        navigationBar.tintColor = .label
//        navigationBar.backgroundColor = .pastelSkyblue
        
//        let navItem = UINavigationItem()
        let settingButton = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"),
            style: .plain, target: self,
            action: #selector(moveToSettingView)
        )
        settingButton.tintColor = UIColor.red
        settingButton.width = 30
        
//        navItem.rightBarButtonItem = settingButton
//        self.navigationItem.rightBarButtonItem = settingButton
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = settingButton
        
        //navigationBar.setItems([navItem], animated: true)
        
        //        let safeArea = self.view.safeAreaLayoutGuide
//        view.addSubview(navigationBar)
//        navigationBar.translatesAutoresizingMaskIntoConstraints = false
       
//        NSLayoutConstraint.activate([
//            navigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
//            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            navigationBar.heightAnchor.constraint(equalToConstant: 56)
//        ])
        
//        navigationBar.tintColor = .label
        
        navigationController?.navigationBar.tintColor = .label
        view.backgroundColor = .pastelSkyblue
    }
    
    override func loadView() {
        self.view = moreMenuView
        
        
    }
    
//    private func setupNavigationBar() {
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            image: UIImage(systemName: "gearshape.fill"),
//            style: .plain,
//            target: self,
//            action: #selector(moveToSettingView)
//        )
//
//
//
//
//    }
    
    @objc func moveToSettingView() {
        // 네비게이션 컨트롤러가 nil이 아니라면 pushViewController 수행
        if let navigationController = self.navigationController {
            let settingViewController = SettingViewController()
            settingViewController.hidesBottomBarWhenPushed = false
            navigationController.pushViewController(settingViewController, animated: true)
        } else {
            // 네비게이션 컨트롤러가 nil이라면 처리할 로직을 추가
            print("네비게이션 컨트롤러가 nil입니다. 예외 처리가 필요합니다.")
        }
    }

    
}


//MARK: - Preview Setting
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct MoreMenuViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "MoreMenus")
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

struct MoreMenuViewController_Preview: PreviewProvider {
    static var previews: some View {
        MoreMenuViewControllerRepresentable()
    }
}
#endif

