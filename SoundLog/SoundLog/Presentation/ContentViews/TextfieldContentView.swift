//
//  TextfieldContentView.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/10/12.
//

import UIKit

class TextfieldContentView: UIView, UIContentView {
	
	struct Configuration: UIContentConfiguration {
		func updated(for state: UIConfigurationState) -> TextfieldContentView.Configuration {
			return TextfieldContentView.Configuration()
		}
		
		 var text: String? = ""
		 var onChange: (String) -> Void = { _ in }
		 
		 func makeContentView() -> UIView & UIContentView {
			  return TextfieldContentView(self)
		 }
	}
	
	let textfield = UITextField()
	
	var configuration: UIContentConfiguration {
		didSet {
			configure(configuration: configuration)
		}
	}
	
	override var intrinsicContentSize: CGSize {
		CGSize(width: 0, height: 48)
	}
	
	init(_ configuration: UIContentConfiguration) {
		self.configuration = configuration
		super.init(frame: .zero)
		addBackgroundView(textfield, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
		textfield.addTarget(textfield, action: #selector(didChange(_:)), for: .editingChanged)
		textfield.clearButtonMode = .whileEditing
		textfield.autocorrectionType = .no
		textfield.returnKeyType = .done
		textfield.delegate = self
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(configuration: UIContentConfiguration) {
		guard let configuration = configuration as? Configuration else { return }
		textfield.text = configuration.text
	}
	
	@objc private func didChange(_ sender: UITextField) {
		guard let configuration = configuration as? TextfieldContentView.Configuration else { return }
		configuration.onChange(textfield.text ?? "")
	}
}

extension UICollectionViewListCell {
	func textFieldConfiguration() -> TextfieldContentView.Configuration {
		TextfieldContentView.Configuration()
	}
}

extension TextfieldContentView: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
