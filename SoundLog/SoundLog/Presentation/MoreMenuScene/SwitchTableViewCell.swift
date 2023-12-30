//
//  SwitchTableViewCell.swift
//  SoundLog
//
//  Created by Nat Kim on 2023/12/10.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    static let identifier = "SwitchTableViewCell"
    public var switchValueChanged: ((Bool) -> Void)?
    
    @objc private func changedSwitchValue(_ sender: UISwitch) {
        switchValueChanged?(sender.isOn)
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .gmsans(ofSize: 15, weight: .GMSansMedium)
        label.textColor = .label
        return label
    }()
    
    private let onOffSwitch: UISwitch = {
        let onOffSwitch = UISwitch()
        onOffSwitch.onTintColor = .neonPurple
        return onOffSwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(onOffSwitch)
        
        contentView.clipsToBounds = true
        accessoryType = .none
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = contentView.frame.size.height - 12
        label.frame = CGRect(
            x: 15,
            y: 0,
            width: contentView.frame.size.width - 40,
            height: contentView.frame.size.height
        )
        
        onOffSwitch.sizeToFit()
        onOffSwitch.frame = CGRect(
            x: contentView.frame.size.width - onOffSwitch.frame.size.width - 20,
            y: (contentView.frame.size.height - onOffSwitch.frame.size.height)/2,
            width: onOffSwitch.frame.size.width,
            height: onOffSwitch.frame.size.height
        )
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        onOffSwitch.isOn = false
    }
    
    public func configure(with model: SettingSwitchOption) {
        label.text = model.title
        onOffSwitch.isOn = model.isOn
        switchValueChanged = { isOn in
            model.handler()
        }
        
        onOffSwitch.addTarget(self, action: #selector(changedSwitchValue(_:)), for: .valueChanged)
    }
}
