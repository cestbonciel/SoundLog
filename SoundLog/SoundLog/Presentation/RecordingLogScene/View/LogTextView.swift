//
//  LogTextView.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/09/21.
//

import UIKit

final class LogTextView: UITextView {
	private enum TextViewConst {
		static let backgroundColor = UIColor.white.withAlphaComponent(0.5)
		static let cornerRadius = 10.0
		static let containerInset = UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 20)
		static let placeholderColor = UIColor.systemDimGray
		static let placeholderFont = UIFont(name: "GmarketSansLight", size: 16.0)
	}
	
	// MARK: - textView
	private lazy var textView: UITextView = {
		let textView = UITextView()
		textView.backgroundColor = .clear
		textView.textColor = TextViewConst.placeholderColor
		
		textView.isUserInteractionEnabled = false
		textView.isAccessibilityElement = false
		return textView
	}()
	
	init() {
		super.init(frame: .zero, textContainer: nil)
		configureUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
	var placeholderText: String? {
		didSet {
			textView.text = placeholderText
			updateTextView()
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		updateTextView()
	}
	
}

extension LogTextView: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		updateTextView()
	}
}

//MARK: - Method

private extension LogTextView {
	func configureUI() {
		delegate = self
		backgroundColor = TextViewConst.backgroundColor
		layer.cornerRadius = TextViewConst.cornerRadius
		clipsToBounds = true
		textContainerInset = TextViewConst.containerInset
		contentInset = .zero
		addSubview(textView)
		
		textView.textContainerInset = TextViewConst.containerInset
		textView.contentInset = contentInset
		textView.font = TextViewConst.placeholderFont
	}
	
	func updateTextView() {
		textView.isHidden = !text.isEmpty
		accessibilityValue = text.isEmpty ? placeholderText ?? "" : text
		
		textView.textContainer.exclusionPaths = textContainer.exclusionPaths
		textView.textContainer.lineFragmentPadding = textContainer.lineFragmentPadding
		textView.frame = bounds
	}
}
