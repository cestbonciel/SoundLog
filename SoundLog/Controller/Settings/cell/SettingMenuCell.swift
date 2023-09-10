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
		return imageView
	}()
	
	lazy var settinglabel: UILabel = {
		let label  = UILabel()
		label.font = UIFont(name: "GMSansMedium", size: 16)
		return label
	}()
	
	public func configure(with image: UIImage, and label: String) {
		self.settingImageView.image = image
		self.settinglabel.text = label
	}
	
	private func setupUI() {
		self.contentView.addSubview(settingImageView)
		self.contentView.addSubview(settinglabel)

		settingImageView.snp.makeConstraints {
			$0.top.bottom.equalToSuperview().inset(12)
			$0.left.equalToSuperview().offset(30)
		}
		settinglabel.snp.makeConstraints{
			$0.top.bottom.equalToSuperview().inset(12)
			$0.left.equalTo(settingImageView.snp.right).inset(-30)
//			$0.right.equalToSuperview().offset(30)
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
