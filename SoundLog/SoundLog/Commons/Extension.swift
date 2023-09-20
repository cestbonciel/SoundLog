//
//  Extension.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/08/18.
//

import Foundation
import UIKit

extension UILabel {
	func labelColor(targetString: String, color: UIColor) {
		let fullText = text ?? ""
		let attributedString = NSMutableAttributedString(string: fullText)
		let range = (fullText as NSString).range(of: targetString)
		attributedString.addAttribute(.foregroundColor, value: color, range: range)
		attributedText = attributedString
	}
}
//MARK: - Custom UIColor
extension UIColor {
	class var pastelSkyblue: UIColor {
		return UIColor(red: 217.0 / 255.0, green: 229.0 / 255.0, blue: 229.0 / 255.0, alpha: 1)
	}
	
	class var neonYellow: UIColor {
		return UIColor(red: 217.0 / 255.0, green: 240.0 / 255.0 , blue: 114.0 / 255.0, alpha: 1)
	}
	
	class var neonPurple: UIColor {
		return UIColor(red: 149.0 / 255.0, green: 146.0 / 255.0, blue: 249.0 / 255.0, alpha: 1)
	}
	
	class var systemDimGray: UIColor {
		return UIColor(red: 176.0 / 255.0, green: 176.0 / 255.0, blue: 176.0 / 255.0, alpha: 1)
	}
	
	class var lightGray: UIColor {
		return UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1)
	}
}
//MARK: - Custom Font
enum SoundLogCustomFont {
	case GMSansLight
	case GMSansMedium
	case GMSansBold
}
extension NSAttributedString {
	class func attributeFont(font: SoundLogCustomFont, size: CGFloat, text: String, lineHeight: CGFloat) -> NSAttributedString {
		let attributeString = NSMutableAttributedString(string: text)
		let paragraphStyle = NSMutableParagraphStyle()
		
		if #available(iOS 14.0, *) {
			paragraphStyle.lineBreakStrategy = .hangulWordPriority
		} else {
			paragraphStyle.lineBreakStrategy = .pushOut
		}
		
		var settingfont = UIFont()
		switch font {
		case .GMSansLight:
			settingfont = UIFont(name: "GmarketSansLight", size: size)!
		case .GMSansMedium:
			settingfont = UIFont(name: "GmarketSansMedium", size: size)!
		case .GMSansBold:
			settingfont = UIFont(name: "GmarketSansBold", size: size)!
		}
		
		paragraphStyle.lineSpacing = lineHeight - settingfont.lineHeight
		
		attributeString.addAttributes([
					NSAttributedString.Key.paragraphStyle : paragraphStyle,
					.font : settingfont
				], range: NSMakeRange(0, attributeString.length))
		
		return attributeString
	}
}
