//
//  SettingCell.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/08/30.
//

import UIKit
import SnapKit

class SettingMenuCell: UITableViewCell {
	static let identifier: String = "SettingMenuCell"
	

	lazy var settingImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.backgroundColor = .systemMint
		return imageView
	}()
	
	lazy var settinglabel: UILabel = {
		let label  = UILabel()
		label.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
		label.backgroundColor = .green
		return label
	}()
	
	lazy var policyLabel: UILabel = {
		let label = UILabel()
		label.font = .gmsans(ofSize: 14, weight: .GMSansLight)
		return label
	}()
	
	public func configure(with image: UIImage, and label: String) {
		self.settingImageView.image = image
		self.settinglabel.text = label
	}
	
	public func defaultConfigure(label: String) {
		self.policyLabel.text = label
		
	}
	
	private func setupUI() {
		self.contentView.addSubview(settingImageView)
		self.contentView.addSubview(settinglabel)
		self.contentView.addSubview(policyLabel)
		
		settingImageView.snp.makeConstraints {
			$0.top.bottom.equalToSuperview().inset(12)
			$0.left.equalToSuperview().offset(30)
		}
		settinglabel.snp.makeConstraints{
			$0.top.bottom.equalToSuperview().inset(12)
			$0.left.equalTo(settingImageView.snp.right).inset(-30)
//			$0.right.equalToSuperview().offset(30)
		}
		
		policyLabel.snp.makeConstraints {
			$0.top.equalTo(settinglabel).offset(32)
			$0.left.equalTo(settingImageView.snp.left).inset(30)
			$0.height.equalTo(48)
		}
	}
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
