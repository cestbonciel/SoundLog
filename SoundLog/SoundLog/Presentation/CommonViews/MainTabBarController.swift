//
//  MainTabBarController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/18.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
	
	@IBOutlet weak var AddTabBar: UITabBarItem!
	@IBOutlet weak var homeTabBar: UITabBar!
	override func viewDidLoad() {
		super.viewDidLoad()
		

		
		let tbItemProxy = UITabBarItem.appearance()
		tbItemProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.neonYellow], for: .selected)
		tbItemProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .disabled)
		let attributes = [NSAttributedString.Key.font:UIFont(name: "GmarketSansMedium", size: 12)]
				tbItemProxy.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
		
			if  let tabBarItem = self.tabBar.items {
				let image1 = UIImage(named: "homeIcon")?.withRenderingMode(.alwaysOriginal)
				tabBarItem[0].image = image1
				
				let selectedImage1 = UIImage(named: "home_highlight")?.withRenderingMode(.alwaysOriginal)
				tabBarItem[0].selectedImage = selectedImage1
				
				let image2 = UIImage(named: "shazam")?.withRenderingMode(.alwaysOriginal)
				tabBarItem[1].image = image2
				
				let selectedImage2 = UIImage(named: "shazamHighlight")?.withRenderingMode(.alwaysOriginal)
				tabBarItem[1].selectedImage = selectedImage2
				
				let image3 = UIImage(named: "moreIcon")?.withRenderingMode(.alwaysOriginal)
				tabBarItem[2].image = image3
				
				let selectedImage3 = UIImage(named: "more_highlight")?.withRenderingMode(.alwaysOriginal)
				tabBarItem[2].selectedImage = selectedImage3
			}

		
	}
	
	
}
