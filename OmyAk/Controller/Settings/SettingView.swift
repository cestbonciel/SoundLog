//
//  SettingView.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/08/29.
//

import UIKit

class SettingView: UIView {
	var profileIcon: UIImageView = {
		let imageView = UIImageView(frame: CGRect(x: 30, y: 122, width: 56, height: 56))
		let profileImage: UIImage = UIImage(named: "profileIcon")!
		imageView.image = profileImage
		return imageView
	}()
	
	var bookmarkIcon: UIImageView = {
		let imageView = UIImageView(frame: CGRect(x: 46, y: 222, width: 32, height: 32))
		let bookmarkImage: UIImage = UIImage(named: "bookmarkIcon")!
		imageView.image = bookmarkImage
		return imageView
	}()
	
	var themeIcon: UIImageView = {
		let imageView = UIImageView(frame: CGRect(x: 46, y: 304, width: 32, height: 32))
		let themeImage: UIImage = UIImage(named: "themeIcon")!
		imageView.image = themeImage
		return imageView
		
	}()
	
	var languageIcon: UIImageView = {
		let imageView = UIImageView(frame: CGRect(x: 46, y: 308, width: 32, height: 32))
		let languageImage: UIImage = UIImage(named: "languageIcon")!
		imageView.image = languageImage
		return imageView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
