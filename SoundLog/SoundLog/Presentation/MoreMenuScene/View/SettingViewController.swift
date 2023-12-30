//
//  SettingViewController.swift
//  SoundLog
//
//  Created by Nat Kim on 2023/11/30.
//

import UIKit
import UserNotifications

import SnapKit

class SettingViewController: UIViewController {
    var models = [Section]()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pastelSkyblue
        title = "설정"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        
        setupUI()
        configure()
        
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(80)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(100)
        }
    }
    
    func configure() {
        models.append(Section(title: "사용자 설정", options: [
            .switchCell(model: SettingSwitchOption(title: "알림설정", isOn: false, handler: {
                let alert = UIAlertController(title: "알림설정", message: "시간을 설정해주세요", preferredStyle: .actionSheet)
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .time
                datePicker.preferredDatePickerStyle = .wheels
                datePicker.locale = Locale(identifier: "ko_KR")
                
                // 한국 시간대로 설정
                if let koreaTimeZone = TimeZone(identifier: "Asia/Seoul") {
                    datePicker.timeZone = koreaTimeZone
                } else {
                    print("Invalid time zone identifier")
                }
                
                let ok = UIAlertAction(title: "설정완료", style: .cancel) { action in
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "ko_KR")
                    dateFormatter.timeZone = datePicker.timeZone
                    dateFormatter.dateFormat = "a hh:mm"
                    
                    print(dateFormatter.string(from: datePicker.date))
                }

                alert.addAction(ok)
                let vc = UIViewController()
                vc.view = datePicker
                alert.setValue(vc, forKey: "contentViewController")
                self.present(alert, animated: true)
            })),
            .staticCell(model: SettingsOption(title: "언어변경", handler: {
                let langVC = LocalizationViewController()
                langVC.isModalInPresentation = true
                langVC.modalPresentationStyle = .pageSheet
                self.present(langVC, animated: true, completion: nil)
            }))
        ]))
        models.append(Section(title: "APP 정보", options: [
            .staticCell(model: SettingsOption(title: "문의하기", handler: {
                
            })),
            .staticCell(model: SettingsOption(title: "오픈소스", handler: {
                
            }))
            
        ]))
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifier,
                for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
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
        case .switchCell(let model):
            model.handler()
        case .staticCell(let model):
            model.handler()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}

//MARK: - User Notification Delegate
extension SettingViewController: UNUserNotificationCenterDelegate {
    
}
