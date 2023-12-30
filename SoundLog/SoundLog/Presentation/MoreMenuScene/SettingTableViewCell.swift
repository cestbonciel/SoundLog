//
//  SettingTableViewCell.swift
//  SoundLog
//
//  Created by Nat Kim on 2023/12/10.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    static let identifier = "SettingTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .gmsans(ofSize: 15, weight: .GMSansMedium)
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(
            x: 15,
            y: 0,
            width: contentView.frame.size.width - 40,
            height: contentView.frame.size.height
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: SettingsOption) {
        label.text = model.title
    }
}
