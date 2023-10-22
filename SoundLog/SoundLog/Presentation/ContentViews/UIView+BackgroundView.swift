//
//  UIView+BackgroundView.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/10/12.
//

import UIKit

extension UIView {
	func addBackgroundView(_ backgroundView: UIView, height: CGFloat? = nil, insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)) {
		addSubview(backgroundView)
		
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
		backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
		backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true
		backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1.0 *  insets.right).isActive = true
		backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1.0 * insets.bottom).isActive = true
		if let height = height {
			backgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true
		}
	}
}
