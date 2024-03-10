//
//  SettingViewController.swift
//  SoundLog
//
//  Created by Nat Kim on 2023/11/30.
//

import UIKit

import SnapKit

class SettingViewController: UIViewController {
    var models = [Section]()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
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
        
//        UNUserNotificationCenter.current().delegate = self
        
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

