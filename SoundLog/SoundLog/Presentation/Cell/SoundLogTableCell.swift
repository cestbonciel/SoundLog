//
//  SoundLogTableCell.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/02/23.
//

import UIKit
import SnapKit

class SoundLogTableCell: UITableViewCell {
    static let identifier: String = "SoundLogCell"
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.45)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemDimGray.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var locationIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "soundSpot")
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCellUI() {
        self.contentView.addSubview(cellView)
        cellView.addSubview(locationIcon)
        
        cellView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(18)
            $0.height.equalTo(129)
        }
    }
    
}
