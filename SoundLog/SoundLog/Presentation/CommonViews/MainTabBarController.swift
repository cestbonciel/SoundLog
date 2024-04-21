//
//  MainTabBarController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/18.
//

import UIKit


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
		
			if  let tabBarItems = self.tabBar.items {
                let baseOffset: CGFloat = -2
                tabBarItems.enumerated().forEach { (index, item) in
                    // 가운데 탭 아이템에 대해서만 더 큰 offset을 적용합니다.
                    let offset = index == 1 ? -10 : baseOffset
                    item.imageInsets = UIEdgeInsets(top: offset, left: 0, bottom: -offset, right: 0)
                }
                
				let image1 = UIImage(named: "homeIcon")?.withRenderingMode(.alwaysOriginal)
				tabBarItems[0].image = image1
				
				let selectedImage1 = UIImage(named: "home_highlight")?.withRenderingMode(.alwaysOriginal)
				tabBarItems[0].selectedImage = selectedImage1
				
				let image2 = UIImage(named: "shazam")?.withRenderingMode(.alwaysOriginal)
				tabBarItems[1].image = image2
				
				let selectedImage2 = UIImage(named: "shazamHighlight")?.withRenderingMode(.alwaysOriginal)
				tabBarItems[1].selectedImage = selectedImage2
				
				let image3 = UIImage(named: "moreIcon")?.withRenderingMode(.alwaysOriginal)
				tabBarItems[2].image = image3
				
				let selectedImage3 = UIImage(named: "more_highlight")?.withRenderingMode(.alwaysOriginal)
				tabBarItems[2].selectedImage = selectedImage3
                
                setupTabBarItemImages(for: tabBarItems)
			}

		
	}
	
    private func setupTabBarItemImages(for tabBarItems: [UITabBarItem]) {
            let isSmallDevice = UIScreen.main.bounds.size.width == 320 && UIScreen.main.bounds.size.height == 568
            let shazamImageSize = isSmallDevice ? CGSize(width: 30, height: 30) : CGSize(width: 60, height: 60)
            
            // 첫 번째 탭: 홈
            let homeImage = UIImage(named: "homeIcon")?.withRenderingMode(.alwaysOriginal)
            tabBarItems[0].image = homeImage
            let homeSelectedImage = UIImage(named: "home_highlight")?.withRenderingMode(.alwaysOriginal)
            tabBarItems[0].selectedImage = homeSelectedImage
            
            // 두 번째 탭: 샤잠
            if let shazamImage = UIImage(named: "shazam")?.resizeImage(to: shazamImageSize).withRenderingMode(.alwaysOriginal),
               let shazamSelectedImage = UIImage(named: "shazamHighlight")?.resizeImage(to: shazamImageSize).withRenderingMode(.alwaysOriginal) {
                tabBarItems[1].image = shazamImage
                tabBarItems[1].selectedImage = shazamSelectedImage
            }
            
            // 세 번째 탭: 더보기
            let moreImage = UIImage(named: "moreIcon")?.withRenderingMode(.alwaysOriginal)
            tabBarItems[2].image = moreImage
            let moreSelectedImage = UIImage(named: "more_highlight")?.withRenderingMode(.alwaysOriginal)
            tabBarItems[2].selectedImage = moreSelectedImage
        }
	
}



extension UIImage {
    func resizeImage(to targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


/*
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
 
 if  let tabBarItems = self.tabBar.items {
 let baseOffset: CGFloat = -2
 tabBarItems.enumerated().forEach { (index, item) in
 // 가운데 탭 아이템에 대해서만 더 큰 offset을 적용합니다.
 
 let offset = index == 1 ? -10 : baseOffset
 item.imageInsets = UIEdgeInsets(top: offset, left: 0, bottom: -offset, right: 0)
 }
 
 let image1 = UIImage(named: "homeIcon")?.withRenderingMode(.alwaysOriginal)
 tabBarItems[0].image = image1
 
 let selectedImage1 = UIImage(named: "home_highlight")?.withRenderingMode(.alwaysOriginal)
 tabBarItems[0].selectedImage = selectedImage1
 
 let image2 = UIImage(named: "shazam")?.withRenderingMode(.alwaysOriginal)
 tabBarItems[1].image = image2
 
 let selectedImage2 = UIImage(named: "shazamHighlight")?.withRenderingMode(.alwaysOriginal)
 tabBarItems[1].selectedImage = selectedImage2
 
 let image3 = UIImage(named: "moreIcon")?.withRenderingMode(.alwaysOriginal)
 tabBarItems[2].image = image3
 
 let selectedImage3 = UIImage(named: "more_highlight")?.withRenderingMode(.alwaysOriginal)
 tabBarItems[2].selectedImage = selectedImage3
 
 setupTabBarItemImages(for: tabBarItems)
 }
 
 
 }
 
 private func setupTabBarItemImages(for tabBarItems: [UITabBarItem]) {
 let isSmallDevice = UIScreen.main.bounds.size.width == 320 && UIScreen.main.bounds.size.height == 568
 let shazamImageSize = isSmallDevice ? CGSize(width: 30, height: 30) : CGSize(width: 60, height: 60)
 
 // 첫 번째 탭: 홈
 let homeImage = UIImage(named: "homeIcon")?.withRenderingMode(.alwaysOriginal)
 tabBarItems[0].image = homeImage
 let homeSelectedImage = UIImage(named: "home_highlight")?.withRenderingMode(.alwaysOriginal)
 tabBarItems[0].selectedImage = homeSelectedImage
 
 // 두 번째 탭: 샤잠
 if let shazamImage = UIImage(named: "shazam")?.resizeImage(to: shazamImageSize).withRenderingMode(.alwaysOriginal),
 let shazamSelectedImage = UIImage(named: "shazamHighlight")?.resizeImage(to: shazamImageSize).withRenderingMode(.alwaysOriginal) {
 tabBarItems[1].image = shazamImage
 tabBarItems[1].selectedImage = shazamSelectedImage
 }
 
 // 세 번째 탭: 더보기
 let moreImage = UIImage(named: "moreIcon")?.withRenderingMode(.alwaysOriginal)
 tabBarItems[2].image = moreImage
 let moreSelectedImage = UIImage(named: "more_highlight")?.withRenderingMode(.alwaysOriginal)
 tabBarItems[2].selectedImage = moreSelectedImage
 }
 
 }
 
 
 
 extension UIImage {
 func resizeImage(to targetSize: CGSize) -> UIImage {
 let size = self.size
 let widthRatio  = targetSize.width  / size.width
 let heightRatio = targetSize.height / size.height
 let newSize: CGSize
 if widthRatio > heightRatio {
 newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
 } else {
 newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
 }
 
 let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
 UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
 self.draw(in: rect)
 let newImage = UIGraphicsGetImageFromCurrentImageContext()!
 UIGraphicsEndImageContext()
 
 return newImage
 }
 }
 
 
 */

/*
 override func viewDidLoad() {
     super.viewDidLoad()
     
     configureTabBarItemStyles()
     if let tabBarItems = self.tabBar.items {
         adjustTabBarItemInsets(tabBarItems: tabBarItems)
         setupTabBarItemImages(for: tabBarItems)
     }
 }
 
 private func configureTabBarItemStyles() {
     let tbItemProxy = UITabBarItem.appearance()
     tbItemProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.neonYellow], for: .selected)
     tbItemProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .disabled)
     let attributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansMedium", size: 12)]
     tbItemProxy.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
 }
 
 private func adjustTabBarItemInsets(tabBarItems: [UITabBarItem]) {
     let tabBarHeight = self.tabBar.frame.size.height
     let halfTabBarHeight = tabBarHeight / 2
     
     // Apply the offset to center tab item's image
     tabBarItems.enumerated().forEach { (index, item) in
         if index == 1 { // Center tab item
             item.imageInsets = UIEdgeInsets(top: -halfTabBarHeight, left: 0, bottom: halfTabBarHeight, right: 0)
         }
     }
 }
 
 private func setupTabBarItemImages(for tabBarItems: [UITabBarItem]) {
     let isSmallDevice = UIScreen.main.bounds.size.width == 320 && UIScreen.main.bounds.size.height == 568
     let shazamImageSize = isSmallDevice ? CGSize(width: 30, height: 30) : CGSize(width: 60, height: 60)
     
     // Set images for the first tab
     let homeImage = UIImage(named: "homeIcon")?.withRenderingMode(.alwaysOriginal)
     tabBarItems[0].image = homeImage
     let homeSelectedImage = UIImage(named: "home_highlight")?.withRenderingMode(.alwaysOriginal)
     tabBarItems[0].selectedImage = homeSelectedImage
     
     // Set images for the center tab
     if let shazamImage = UIImage(named: "shazam")?.resizeImage(to: shazamImageSize).withRenderingMode(.alwaysOriginal),
        let shazamSelectedImage = UIImage(named: "shazamHighlight")?.resizeImage(to: shazamImageSize).withRenderingMode(.alwaysOriginal) {
         tabBarItems[1].image = shazamImage
         tabBarItems[1].selectedImage = shazamSelectedImage
     }
     
     // Set images for the third tab
     let moreImage = UIImage(named: "moreIcon")?.withRenderingMode(.alwaysOriginal)
     tabBarItems[2].image = moreImage
     let moreSelectedImage = UIImage(named: "more_highlight")?.withRenderingMode(.alwaysOriginal)
     tabBarItems[2].selectedImage = moreSelectedImage
 }
}

extension UIImage {
 func resizeImage(to targetSize: CGSize) -> UIImage {
     let size = self.size
     let widthRatio = targetSize.width / size.width
     let heightRatio = targetSize.height / size.height
     let newSize: CGSize
     if widthRatio > heightRatio {
         newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
     } else {
         newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
     }
     
     let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
     UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
     self.draw(in: rect)
     let newImage = UIGraphicsGetImageFromCurrentImageContext()!
     UIGraphicsEndImageContext()
     
     return newImage
 }
 
 */
