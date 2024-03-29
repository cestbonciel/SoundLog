//
//  SoundLogTableCell.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/02/23.
//

import UIKit
import SnapKit

protocol SoundLogTableCellDelegate: AnyObject {
    func didToggleBookmark(for cell: SoundLogTableCell)
}

class SoundLogTableCell: UITableViewCell {
    static let identifier: String = "SoundLogCell"
    
    weak var delegate: SoundLogTableCellDelegate?
    
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
        label.text = ""
        label.font = .gmsans(ofSize: 12, weight: .GMSansLight)
        return label
    }()
   
    lazy var bookmarkIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "bookmark")
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .neonPurple
        return icon
    }()
    
    lazy var categoryIcon: CategoryIconView = {
        let icon = CategoryIconView(type: .asmr)
  
        return icon
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
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
    
    // MARK: - Configure
    func configure(with soundLog: StorageSoundLog) {
        self.locationIcon.image = UIImage(named: "soundSpot")
        self.locationLabel.text = soundLog.soundLocation
        
       
        //self.bookmarkIcon.image = UIImage(systemName: "bookmark")
        let isBookmarked = BookmarkSoundLog.isBookmarked(for: soundLog)
        updateBookmarkIcon(isBookmarked: isBookmarked)
        
        setupBookmarkGesture()
    
        self.moodLabel.text = soundLog.soundMood
        self.titleLabel.text = soundLog.soundTitle
        self.timeLogLabel.text = soundLog.createdAt.toTimeString
        let categoryType: CategoryIconType = soundLog.soundCategory == "ASMR" ? .asmr : .recording
        categoryIcon.setupView(type: categoryType)
        
        if let recordedFileUrlString = soundLog.soundRecordFile?.recordedFileUrl,
           let url = URL(string: recordedFileUrlString) {
            print("녹음된 파일: \(url)")
            // 파일 시스템 상에서 실제 파일 존재 여부를 로그로 출력합니다.
            let fileExists = FileManager.default.fileExists(atPath: url.path)
            print("@@@ 파일 존재 여부: \(fileExists) @@@")
            print("@@@ 파일 존재 여부: \(url.path) @@@")
            
            if fileExists {
                customPlayerView.queueSound(url: url)
                
            } else {
                print("@@@ file Error: 오디오 파일 URL이 유효하지 않습니다. 경로: \(url.path)")
                // 여기서 사용자에게 오류 메시지를 표시하거나 적절한 처리를 할 수 있습니다.
            }
        } else {
            print("file Error: 녹음된 파일의 URL이 없거나 잘못되었습니다.")
            // 적절한 사용자 피드백을 제공합니다.
        }
    }
    
    private func updateBookmarkIcon(isBookmarked: Bool) {
        let bookmarkImageName = isBookmarked ? "bookmark.fill" : "bookmark"
        bookmarkIcon.image = UIImage(systemName: bookmarkImageName)
    }
    
    private func setupBookmarkGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleBookmark))
        bookmarkIcon.isUserInteractionEnabled = true
        bookmarkIcon.addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleBookmark() {
        print("Bookmark icon tapped.")
        delegate?.didToggleBookmark(for: self)
    }
    
    @objc func playRecordAudio() {
        print("재생 버튼이 눌림")
        customPlayerView.playbuttonTapped()
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

/*
 customPlayerView.playAndPauseBtn.addTarget(self, action: #selector(playRecordAudio), for: .touchUpInside)
 
 if let recordedFileName = soundLog.soundRecordFile?.recordedFileUrl {
     //Initializer for conditional binding must have Optional type, not 'String'
     let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
     let recordedFileURL = documentDirectory.appendingPathComponent(recordedFileName)
     customPlayerView.queueSound(url: recordedFileURL)
 }
 */

/*
 
 if let recordedFileName = soundLog.soundRecordFile?.recordedFileUrl,
    let url = URL(string: recordedFileName) {
     print("녹음된 파일: \(url)")
     if FileManager.default.fileExists(atPath: url.path) {
         print("파일이 존재함: \(url.path)")
         customPlayerView.queueSound(url: url)
     } else {
         print("file Error: 파일이 존재하지 않음. 경로: \(url.path)")
         // 경로가 유효하지 않을 때 보다 상세한 디버깅 정보를 출력할 수 있습니다.
     }
     customPlayerView.playAndPauseBtn.addTarget(self, action: #selector(playRecordAudio), for: .touchUpInside)
 } else {
     print("file Error: 저장된 녹음 파일 URL이 잘못되었거나 없음.")
 }
 
 if let recordedFileName = soundLog.soundRecordFile,
    let url = URL(string: recordedFileName.recordedFileUrl) {
     //Initializer for conditional binding must have Optional type, not 'String'
     print("녹음된 파일: \(url)")
     if FileManager.default.fileExists(atPath: url.path) {
         customPlayerView.queueSound(url: url)
     } else {
         print("file Error: 오디오 파일 URL 이 유효하지 않음.")
     }
     customPlayerView.playAndPauseBtn.addTarget(self, action: #selector(playRecordAudio), for: .touchUpInside)
 }
 
if let recordedFileName = soundLog.soundRecordFile,
   let url = URL(string: recordedFileName.recordedFileUrl) {
    //Initializer for conditional binding must have Optional type, not 'String'
    print("녹음된 파일: \(url)")
    if FileManager.default.fileExists(atPath: url.path) {
        customPlayerView.queueSound(url: url)
    } else {
        print("file Error: 오디오 파일 URL 이 유효하지 않음.")
    }
    customPlayerView.playAndPauseBtn.addTarget(self, action: #selector(playRecordAudio), for: .touchUpInside)
}
*/
