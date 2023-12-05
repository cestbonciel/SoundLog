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
        
        let settingButton = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"),
            style: .plain, target: self,
            action: #selector(moveToSettingView)
        )
        settingButton.tintColor = UIColor.red
        settingButton.width = 30
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = settingButton
        
        self.navigationController?.navigationBar.tintColor = .label
        view.backgroundColor = .pastelSkyblue
        self.setCustomNaviBarButton()
    }
    
    override func loadView() {
        self.view = moreMenuView
    }
    
    private func setCustomNaviBarButton() {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        rightView.backgroundColor = .magenta
        rightView.layer.borderWidth = 1
        
        let rightBarBtn = UIBarButtonItem(customView: rightView)
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
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

