//
//  SceneDelegate.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/08/03.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		
		if UserDefaults.standard.string(forKey: "nickname") == nil {
			if let mainVC = UIStoryboard(name: "startEnter", bundle: nil).instantiateViewController(withIdentifier: "InputNickname") as? StartViewController {
				window?.rootViewController = mainVC
			}
		} else {
			let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar")
			window?.rootViewController = tabBarVC
		}
		let appearance = UINavigationBarAppearance()
		let backItemAppearance = UIBarButtonItemAppearance()
		
		UINavigationBar.appearance().tintColor = .black
		guard let _ = (scene as? UIWindowScene) else { return }
		
		let tabBarAppearance = UITabBarAppearance()
		tabBarAppearance.backgroundColor = .black
		
		let tbItemProxy = UITabBarItem.appearance()
		tbItemProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.neonYellow], for: .selected)
		tbItemProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .disabled)
		let attributes = [NSAttributedString.Key.font:UIFont(name: "GmarketSansMedium", size: 12)]
				tbItemProxy.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
		
		if let tabBarCustom = self.window?.rootViewController as? UITabBarController {
			
			if  let tabBarItem = tabBarCustom.tabBar.items {
				let image1 = UIImage(named: "homeIcon")?.withRenderingMode(.alwaysOriginal)
				tabBarItem[0].image = image1
				
				let selectedImage1 = UIImage(named: "home_highlight")?.withRenderingMode(.alwaysOriginal)
				tabBarItem[0].selectedImage = selectedImage1
				
				let image2 = UIImage(named: "AddBtn")?.withRenderingMode(.alwaysOriginal)
				tabBarItem[1].image = image2
				
				let image3 = UIImage(named: "moreIcon")?.withRenderingMode(.alwaysOriginal)
				tabBarItem[2].image = image3
				
				let selectedImage3 = UIImage(named: "more_highlight")?.withRenderingMode(.alwaysOriginal)
				tabBarItem[2].selectedImage = selectedImage3
			}
		}
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.
	}


}

