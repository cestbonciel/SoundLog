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
    func didTapEditButton(for cell: SoundLogTableCell)
}

class SoundLogTableCell: UITableViewCell {
    static let identifier: String = "SoundLogCell"
    
    var soundLog: StorageSoundLog?
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
        icon.tintColor = .black
        return icon
    }()
    
    lazy var categoryIcon: CategoryIconView = {
        let icon = CategoryIconView(type: .recording)
  
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
    
    //MARK: - 수정/삭제 화면
    lazy var editButton: UIButton = {
        var attString = AttributedString("Edit")
        attString.font = .gmsans(ofSize: 12, weight: .GMSansMedium)
        
        var config = UIButton.Configuration.borderedTinted()
        config.attributedTitle = attString
        config.baseBackgroundColor = .systemRed
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        let button = UIButton(configuration: config)
        button.configuration = config
        button.tintColor = .systemRed
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func editButtonTapped() {
        delegate?.didTapEditButton(for: self)
    }
    
    // MARK: - CustomPlayerView
    //private lazy var customPlayerView: CustomPlayerView = CustomPlayerView()
    var customPlayerView: CustomPlayerView?
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
        self.soundLog = soundLog
        self.locationIcon.image = UIImage(named: "soundSpot")
        self.locationLabel.text = soundLog.soundLocation
        
    
        updateBookmarkIcon(isBookmarked: BookmarkSoundLog.isBookmarked(for: soundLog))
        
        setupBookmarkGesture()
    
        self.moodLabel.text = soundLog.soundMood
        self.titleLabel.text = soundLog.soundTitle
        self.timeLogLabel.text = soundLog.createdAt.toTimeString
        let categoryType: CategoryIconType = soundLog.soundCategory == "ASMR" ? .asmr : .recording
        categoryIcon.setupView(type: categoryType)
        
        if let urlString = soundLog.soundRecordFile?.recordedFileUrl,
           let url = URL(string: urlString) {
            if customPlayerView == nil {
                customPlayerView = CustomPlayerView(soundURL: url, frame: .zero)
                cellView.addSubview(customPlayerView!)
                setupCustomPlayerViewConstraints()
            } else {
                customPlayerView?.queueSound(url: url)
            }
        }
    }
    
    private func setupCustomPlayerViewConstraints() {
        customPlayerView?.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(8)
            make.height.equalTo(50) // 적절한 높이 값
        }
    }
    
    func updateBookmarkIcon(isBookmarked: Bool) {
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
    
    
    
    private func setUpCellUI() {
        self.contentView.addSubview(cellView)
        cellView.addSubview(locationIcon)
        cellView.addSubview(locationLabel)
        cellView.addSubview(categoryIcon)
        cellView.addSubview(bookmarkIcon)
        cellView.addSubview(titleLabel)
        cellView.addSubview(rightStackView)
        //cellView.addSubview(customPlayerView)
        cellView.addSubview(editButton)
        
        cellView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(160)
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
            $0.right.equalTo(bookmarkIcon.snp.left).offset(-8)
            $0.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(16)
            $0.left.equalTo(locationIcon.snp.left)
        }
        
//        customPlayerView.snp.makeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
//            $0.left.right.equalToSuperview()
//
//        }
        
        editButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.right.equalTo(bookmarkIcon.snp.right)
        }
        
        rightStackView.snp.makeConstraints {
            $0.top.equalTo(bookmarkIcon.snp.bottom).offset(8)
            $0.right.equalToSuperview().inset(16)
            
        }

    }
    
}

