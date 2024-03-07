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
        view.backgroundColor = .pastelSkyblue
        navigationController?.navigationBar.tintColor = .label
        configureNaviBarButton()
    }
    
    override func loadView() {
        self.view = moreMenuView
        
    }
    
    private func configureNaviBarButton() {
//        navigationController?.navigationBar.barTintColor = .yellow
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"),
            style: .plain,
            target: self,
            action: #selector(moveToSettingView)
        )
    }
    
    @objc func moveToSettingView() {
        if let navigationController = self.navigationController {
            let settingViewController = SettingViewController()
            settingViewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(settingViewController, animated: true)
        } else {
            print("네비게이션 컨트롤러가 nil입니다. 예외 처리가 필요합니다.")
        }
    }
    
    
}


//MARK: - Preview Setting

#if DEBUG
import SwiftUI
struct Preview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
       MoreMenuViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

struct MoreMenuViewController_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            Preview()
        }
    }
}
#endif
