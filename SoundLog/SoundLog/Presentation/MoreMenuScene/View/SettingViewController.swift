//
//  SettingViewController.swift
//  SoundLog
//
//  Created by Nat Kim on 2023/11/30.
//

import UIKit
import MessageUI

import AcknowList
import SnapKit

class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {
    var models = [Section]()
    
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pastelSkyblue
        title = "App 정보"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        
        setupUI()
        configure()

    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(100)
        }
        
    }
    
    func configure() {
        models.append(Section(options: [
            .staticCell(model: SettingsOption(title: "의견 보내기", handler: {
                if MFMailComposeViewController.canSendMail() {
                    let composeViewController = MFMailComposeViewController()
                    composeViewController.mailComposeDelegate = self
                    
                    let bodyString = """
                                     개선 사항, 문의 내용을 작성해주세요.
                                     
                                     
                                     
                                     
                                     
                                     ---------------------------
                                     Device Model: \(Device.getDeviceModelName())
                                     Device OS:    \(UIDevice.current.systemVersion)
                                     App Version:  \(Device.getAppVersion())
                                     ---------------------------
                                     """
                    composeViewController.setToRecipients(["cestbonciel@gmail.com"])
                    composeViewController.setSubject("[소리의 기록] 의견 및 피드백")
                    composeViewController.setMessageBody(bodyString, isHTML: false)
                    
                    self.present(composeViewController, animated: true, completion: nil)
                } else {
                    let sendMailErrorAlert = UIAlertController(
                        title: "메일 전송 실패",
                        message: "Mail 앱이 없습니다. 앱스토어에서 해당 앱을 다운받고 이메일 설정 확인 후 다시 시도해주세요.",
                        preferredStyle: .alert
                    )
                    let goAppStoreAction = UIAlertAction(
                        title: "앱스토어로 이동",
                        style: .default
                    ) { _ in
                        if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"),
                           UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(
                                    url,
                                    options: [:],
                                    completionHandler: nil
                                )
                                
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    }//: goAppStoreAction
                    let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                    sendMailErrorAlert.addAction(goAppStoreAction)
                    sendMailErrorAlert.addAction(cancelAction)
                    self.present(sendMailErrorAlert, animated: true, completion: nil)
                }
            })),
            .staticCell(model: SettingsOption(title: "오픈소스", handler: {
                let vc = AcknowListViewController()
                vc.navigationItem.title = "오픈소스"
                self.navigationController?.pushViewController(vc, animated: true)
            })),
            .staticCell(model: SettingsOption(title: "버전정보", handler: {
                
                
            }))
            
        ]))
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTableViewCell.identifier,
                for: indexPath) as? SettingTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
        switch type.self {
        case .staticCell(let model):
            model.handler()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}

#if DEBUG
import SwiftUI
struct SettingViewPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
       SettingViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct SettingViewController_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SettingViewPreview()
        }
    }
}
#endif
