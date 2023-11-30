//
//  MoreMenuCell.swift
//  SoundLog
//
//  Created by Nat Kim on 2023/11/29.
//

import UIKit
import SnapKit


class MoreMenuCell: UITableViewCell {
    
    weak var delegate: MoreMenuViewDelegate?
    
    static let identifier: String = "MoreCell"
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .gmsans(ofSize: 14, weight: .GMSansMedium)
        label.text = "뮤덕이 님의 소리 저장소"
        return label
    }()
    
    lazy var modifiedButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.titleLabel?.textColor = .label

        button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        //button.addTarget(self, action: #selector(modifiedButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var bookmarkLabel: UILabel = {
        let label = UILabel()
        label.font = .gmsans(ofSize: 14, weight: .GMSansMedium)
        label.text = "북마크"
        return label
    }()

    lazy var bookmarkIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bookmarkIcon")
        imageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        return imageView
    }()
    
    @objc func modifiedButtonTapped(_ sender: UIButton) {
        delegate?.didTapModifiedButton()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupTableView()
        self.modifiedButton.addTarget(self, action: #selector(modifiedButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        self.contentView.addSubview(userNameLabel)
        self.contentView.addSubview(modifiedButton)
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        modifiedButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
