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
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .black
        return icon
    }()
    
    lazy var categoryIcon: CategoryIconView = {
        let icon = CategoryIconView(type: .asmr)
  
        return icon
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "바닷소리가 좋다"
        label.font = .gmsans(ofSize: 12, weight: .GMSansMedium)
        return label
    }()
    
    lazy var timeLogLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .gmsans(ofSize: 10, weight: .GMSansLight)
        return label
    }()
    
    lazy var moodLabel: UILabel = {
        let moodLabel = UILabel()
        moodLabel.text = ""
        moodLabel.font = .systemFont(ofSize: 12)
        return moodLabel
    }()
    
    lazy var rightStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLogLabel, moodLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var customPlayerView: CustomPlayerView = CustomPlayerView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setUpCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            cellView.layer.borderWidth = 1
            cellView.layer.borderColor = UIColor.neonPurple.cgColor
        } else {
            cellView.layer.borderWidth = 1
            cellView.layer.borderColor = UIColor.systemDimGray.cgColor
        }
    }
    /*
    func configure(_ soundInfo: SoundInfo) {
        self.locationIcon.image = UIImage(named: "soundSpot")
        self.locationLabel.text = soundInfo.soundLocation
        self.bookmarkIcon.image = UIImage(systemName: "bookmark")
        self.moodLabel.text = String(soundInfo.soundMood)
        self.titleLabel.text = soundInfo.soundTitle
        self.timeLogLabel.text = soundInfo.createdAt.toTimeString
    }
    */
    
    func configure(with soundLog: StorageSoundLog) {
        self.locationIcon.image = UIImage(named: "soundSpot")
        self.locationLabel.text = soundLog.soundLocation
        self.bookmarkIcon.image = UIImage(systemName: "bookmark")
        self.moodLabel.text = soundLog.soundMood
        self.titleLabel.text = soundLog.soundTitle
        self.timeLogLabel.text = soundLog.createdAt.toTimeString
        let categoryType: CategoryIconType = soundLog.soundCategory == "ASMR" ? .asmr : .recording
        categoryIcon.setupView(type: categoryType)
        
        if let recordedFileName = soundLog.soundRecordFile?.recordedFileUrl {
            //Initializer for conditional binding must have Optional type, not 'String'
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let recordedFileURL = documentDirectory.appendingPathComponent(recordedFileName)
            customPlayerView.queueSound(url: recordedFileURL)
        }
        
        /*
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let recordedFileURL = documentDirectory.appendingPathComponent(soundLog.recordedFileUrl.recordedFileUrl)
        customPlayerView.queueSound(url: recordedFileURL)
        */
        
    }
    
    private func setUpCellUI() {
        self.contentView.addSubview(cellView)
        cellView.addSubview(locationIcon)
        cellView.addSubview(locationLabel)
        cellView.addSubview(categoryIcon)
        cellView.addSubview(bookmarkIcon)
        cellView.addSubview(titleLabel)
        cellView.addSubview(rightStackView)
        cellView.addSubview(customPlayerView)
        
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
            $0.top.equalTo(locationIcon.snp.top)
            $0.left.equalTo(locationIcon.snp.right).offset(5)
        }

        bookmarkIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.right.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        
        categoryIcon.snp.makeConstraints {
            $0.centerY.equalTo(bookmarkIcon.snp.centerY)
            $0.right.equalTo(bookmarkIcon.snp.left).offset(-16)
            $0.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(16)
            $0.left.equalTo(locationIcon.snp.left)
        }
        
        customPlayerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.left.right.equalToSuperview()
            
        }
        
        rightStackView.snp.makeConstraints {
            $0.top.equalTo(bookmarkIcon.snp.bottom).offset(8)
            $0.right.equalToSuperview().inset(16)
            
        }
        
    }
    
}
