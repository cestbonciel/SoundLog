//
//  SceneDelegate.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/03.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        var rootViewController: UIViewController
        
        if UserDefaults.standard.string(forKey: "nickname") == nil {
            let startViewController = UIStoryboard(name: "startEnter", bundle: nil).instantiateViewController(withIdentifier: "InputNickname") as! StartViewController
            rootViewController = UINavigationController(rootViewController: startViewController)
        } else {
            // 닉네임이 이미 저장되어 있다면 메인 화면을 표시
            let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar")
            rootViewController = UINavigationController(rootViewController: tabBarVC)
        }
        
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        
        let appearance = UINavigationBarAppearance()
        let backItemAppearance = UIBarButtonItemAppearance()
        
        UINavigationBar.appearance().tintColor = .black
        //        UINavigationBar.appearance().tintColor = .black
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .black
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

