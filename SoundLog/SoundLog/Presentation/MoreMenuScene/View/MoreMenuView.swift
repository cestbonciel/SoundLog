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
        label.font = .gmsans(ofSize: 15, weight: .GMSansMedium)
        label.text = "당신을 위한 소리 기록장"
        label.textColor = .systemDimGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var bookmarkStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bookmarkIcon, bookmarkLabel])
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.distribution = .equalSpacing
        
        stackView.spacing = 8
        return stackView
    }()

    private lazy var bookmarkLabel: UILabel = {
        let label = UILabel()
        label.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        label.text = "북마크한 소리기록"
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
    
    lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.font = .gmsans(ofSize: 15, weight: .GMSansMedium)
        label.text = "북마크한 소리의 기록이 없습니다."
        label.textColor = .systemDimGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SoundLogTableCell.self, forCellReuseIdentifier: SoundLogTableCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
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
        //self.addSubview(nicknameStack)
        self.addSubview(bookmarkStack)
        self.addSubview(noticeLabel)
        
        introLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.left.equalToSuperview().inset(24)
        }

        bookmarkStack.snp.makeConstraints {
            $0.top.equalTo(introLabel.snp.bottom).offset(24)
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
        
        noticeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
//        tableView.dataSource = self
//        tableView.delegate = self
        
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(bookmarkStack.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }

    }
}

