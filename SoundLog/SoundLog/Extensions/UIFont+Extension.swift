//
//  UIFont+Extension.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/10/30.
//

import UIKit

extension UIFont {
	enum GMSansWeight: String {
		case GMSansLight = "GmarketSansTTFLight"
		case GMSansMedium = "GmarketSansTTFMedium"
		case GMSansBold = "GmarketSansTTFBold"
	}
	
	static func gmsans(ofSize fontSize: CGFloat, weight: UIFont.GMSansWeight) -> UIFont {
		let font = UIFont(name: weight.rawValue, size: fontSize)
		
		return font ?? UIFont.systemFont(ofSize: 16, weight: .regular)
	}
	
	enum PrtendardWeight: String {
		case PRTendardExtraLight = "Pretendard-ExtraLight"
		case PRTendardLight = "Pretendard-Light"
		case PRTendardRegular = "Pretendard-Regular"
		case PRTendardMedium = "Pretendard-Medium"
		case PRTendardBold = "Pretendard-Bold"
	}
	
	static func prtendard(ofSize fontSize: CGFloat, weight: UIFont.PrtendardWeight) -> UIFont {
		let font = UIFont(name: weight.rawValue, size: fontSize)
		
		return font ?? UIFont.systemFont(ofSize: 16, weight: .regular)
	}
}

