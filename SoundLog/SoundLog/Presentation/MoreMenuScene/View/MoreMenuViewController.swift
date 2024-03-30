//
//  MoreMenuViewController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/28.
//

import UIKit
import SnapKit

class MoreMenuViewController: UIViewController {
    var bookmarkedLogs: [StorageSoundLog] = []
    
    lazy var moreMenuView = MoreMenuView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pastelSkyblue
        navigationController?.navigationBar.tintColor = .label
        configureNaviBarButton()
        
        moreMenuView.tableView.delegate = self
        moreMenuView.tableView.dataSource = self
    }
    
    override func loadView() {
        self.view = moreMenuView

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    private func configureNaviBarButton() {
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
    
    func updateUI() {
        fetchBookmarkedLogs()
        moreMenuView.noticeLabel.isHidden = !bookmarkedLogs.isEmpty
        moreMenuView.tableView.isHidden = bookmarkedLogs.isEmpty
        moreMenuView.tableView.reloadData()
    }
    
    func fetchBookmarkedLogs() {
        let allLogs = StorageSoundLog.getAllObjects()
        
        bookmarkedLogs = allLogs.filter {
            BookmarkSoundLog.isBookmarked(for: $0)
        }
        moreMenuView.tableView.reloadData()
        //Reference to member 'reloadData' cannot be resolved without a contextual type
    }
    
}

extension MoreMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedLogs.count
        //Cannot find 'bookmarkedLogs' in scope
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var categoryIcon = CategoryIconType.Type.self
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SoundLogTableCell.identifier, for: indexPath) as? SoundLogTableCell else { fatalError("Unable to dequeue SoundLogTableCell") }
        let soundLog = bookmarkedLogs[indexPath.row]
        cell.configure(with: soundLog)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
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
