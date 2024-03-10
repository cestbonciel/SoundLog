//
//  MoreMenuView.swift
//  SoundLog
//
//  Created by Nat Kim on 2023/12/02.
//
import UIKit
import SnapKit

class MoreMenuView: UIView {
 
    private lazy var introLabel: UILabel = {
        let label = UILabel()
        label.font = .gmsans(ofSize: 12, weight: .GMSansMedium)
        label.text = "당신을 위한 소리 기록장"
        label.textColor = .systemDimGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nicknameStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userNickname, modifiedButton])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var bookmarkStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bookmarkIcon, bookmarkLabel])
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        stackView.distribution = .equalSpacing
        
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var userNickname: UILabel = {
        let label = UILabel()
        label.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        label.text = "뮤덕이" // TODO: - 나중에 사용자 닉네임 값 받아오는 걸로 변경해야함
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var modifiedButton: UIButton = {
        var attrStr = AttributedString("변경")
        attrStr.font = .gmsans(ofSize: 14, weight: .GMSansMedium)
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attrStr
        config.baseForegroundColor = .black
        config.titlePadding = 8
        config.imagePadding = 8
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let buttonInstance = UIButton(configuration: config)
        buttonInstance.frame = CGRect(x: 0, y: 0, width: 48, height: 24)
        buttonInstance.tintColor = .lightGray
        
        buttonInstance.layer.cornerRadius = 10
        
        return buttonInstance
    }()

    

    @objc func modifiedButtonTapped() {
        //view.backgroundColor = .systemGreen.withAlphaComponent(0.4)
        let viewController = MoreMenuViewController()
        viewController.modalTransitionStyle = .crossDissolve
        //view.modalPresentationStyle = .overFullScreen
        //present(viewController, animated: true, completion: nil)
    }
    

    private lazy var bookmarkLabel: UILabel = {
        let label = UILabel()
        label.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        label.text = "북마크"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bookmarkIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "bookmarkIcon")
        
        icon.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(introLabel)
        self.addSubview(nicknameStack)
        self.addSubview(bookmarkStack)
        introLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.left.right.equalToSuperview().offset(30)
        }
        
        nicknameStack.snp.makeConstraints {
            $0.top.equalTo(introLabel.snp.bottom).offset(48)
            $0.left.right.equalToSuperview().inset(24)
        }
        
        userNickname.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        modifiedButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        bookmarkStack.snp.makeConstraints {
            $0.top.equalTo(nicknameStack.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(24)
            $0.height.equalTo(32)
        }

        
        bookmarkIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(32)
        }
        bookmarkLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            
        }
        
    }
}
