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
	
	func anotherlabel(targetString: String, color: UIColor) {
		let fullText = text ?? ""
		let anotherAttributedString = NSMutableAttributedString(string: fullText)
		let range = (fullText as NSString).range(of: targetString)
		anotherAttributedString.addAttribute(.foregroundColor, value: color, range: range)
		attributedText = anotherAttributedString
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
enum SoundLogCustomFontGM {
	case GMSansLight
	case GMSansMedium
	case GMSansBold
}

enum SoundLogCustomFontPret {
	case PRdardBold
	case PRdardExtraBold
	case PRdardExtraLight
	case PRdardLight
	case PRdardMedium
	case PRdardRegular
	case PRdardSemibold
	case PRdardThin
}

extension NSAttributedString {
	class func attributeFont(font: SoundLogCustomFontGM, size: CGFloat, text: String, lineHeight: CGFloat) -> NSAttributedString {
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
	
	class func anotherAttributeFont(font: SoundLogCustomFontPret, text: String, size: CGFloat, lineHeight: CGFloat) -> NSAttributedString {
		let anotherAttributeString = NSMutableAttributedString(string: text)
		let paragraphStyle = NSMutableParagraphStyle()
		
		if #available(iOS 14.0, *) {
			paragraphStyle.lineBreakStrategy = .hangulWordPriority
		} else {
			paragraphStyle.lineBreakStrategy = .pushOut
		}
		
		var settingfont = UIFont()
		switch font {
		case .PRdardBold:
			settingfont = UIFont(name: "Pretendard-Bold", size: size)!
		case .PRdardMedium:
			settingfont = UIFont(name: "Pretendard-Medium", size: size)!
			//?? UIFont.systemFont(ofSize: size)
			//settingfont = UIFont(name: "GmarketSansMedium", size: size)!
		case .PRdardRegular:
			settingfont = UIFont(name: "Pretendard-Regular", size: size)!
		case .PRdardExtraBold:
			settingfont = UIFont(name: "Pretendard-ExtraBold", size: size)!
		case .PRdardExtraLight:
			settingfont = UIFont(name: "Pretendard-ExtraLight", size: size)!
		case .PRdardLight:
			settingfont = UIFont(name: "Pretendard-Light", size: size)!
		case .PRdardSemibold:
			settingfont = UIFont(name: "Pretendard-SemiBold", size: size)!
		case .PRdardThin:
			settingfont = UIFont(name: "Pretendard-Thin", size: size)!
		}
		paragraphStyle.lineSpacing = lineHeight - settingfont.lineHeight
		
		anotherAttributeString.addAttributes([
					NSAttributedString.Key.paragraphStyle : paragraphStyle,
					.font : settingfont
				], range: NSMakeRange(0, anotherAttributeString.length))
		
		return anotherAttributeString
	}
}
