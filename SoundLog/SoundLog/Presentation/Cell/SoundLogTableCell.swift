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
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "강원도 속초바닷가"
        label.font = .gmsans(ofSize: 12, weight: .GMSansLight)
        return label
    }()
    
    lazy var bookmarkIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "bookmark")
        icon.tintColor = .black
        return icon
    }()
    
    lazy var moodLabel: UILabel = {
        let moodLabel = UILabel()
        moodLabel.text = "😂"
        moodLabel.font = .systemFont(ofSize: 12)
        return moodLabel
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "바닷소리가 좋다"
        label.font = .gmsans(ofSize: 12, weight: .GMSansMedium)
        return label
    }()
    
    lazy var timeLogLabel: UILabel = {
        let label = UILabel()
        label.text = "21:00 P.M."
        label.font = .gmsans(ofSize: 10, weight: .GMSansLight)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setUpCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ soundInfo: SoundInfo) {
        self.locationIcon.image = UIImage(named: "soundSpot")
        self.locationLabel.text = soundInfo.soundLocation
        self.bookmarkIcon.image = UIImage(systemName: "bookmark")
        self.moodLabel.text = String(soundInfo.soundMood)
        self.titleLabel.text = soundInfo.soundTitle
        self.timeLogLabel.text = soundInfo.createdAt
    }
    
    private func setUpCellUI() {
        self.contentView.addSubview(cellView)
        cellView.addSubview(locationIcon)
        cellView.addSubview(locationLabel)
        cellView.addSubview(bookmarkIcon)
        cellView.addSubview(moodLabel)
        cellView.addSubview(titleLabel)
        cellView.addSubview(timeLogLabel)
        
        cellView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(129)
        }
        
        locationIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.equalToSuperview().inset(16)
            $0.height.equalTo(11)
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(locationIcon)
            $0.left.equalTo(locationIcon.snp.right).offset(5)
        }
        
        
    }
    
}
