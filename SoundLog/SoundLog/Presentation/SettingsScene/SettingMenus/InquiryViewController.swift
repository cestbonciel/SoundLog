//
//  InquiryViewController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/11/11.
//

import UIKit

class InquiryViewController: UIViewController {
	weak var label: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemGreen
		label.text = "테스트"
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			label.centerYAnchor.constraint(equalTo:view.centerYAnchor)
		])
	}
}
