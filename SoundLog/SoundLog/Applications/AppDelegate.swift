//
//  AppDelegate.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/03.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//		 Override point for customization after application launch.
		UINavigationBar.appearance().tintColor = UIColor.black // NavigationBar의 아이템 색상을 흰색으로 설정
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] // NavigationBar 타이틀 색상을 흰색으로 설정
		
		// UIBarButtonItem의 스타일을 정의합니다.
		let barButtonItemAppearance = UIBarButtonItem.appearance()
		barButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal) // UIBarButtonItem의 일반 상태 텍스트 색상을 흰색으로 설정
        /*
        let config = Realm.Configuration(
            schemaVersion: 2, // 새로운 스키마 버전 설정
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // 1-1. 마이그레이션 수행(버전 2보다 작은 경우 버전 2에 맞게 데이터베이스 수정)
                    migration.enumerateObjects(ofType: UserInformation.className()) { oldObject, newObject in
                        newObject!["birthday"] = Date()
                    }
                }
            }
        )
        */
        // MARK: - Realm
        let config = Realm.Configuration(
            schemaVersion: 2) { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    migration.enumerateObjects(ofType: StorageSoundLog.className()) { oldObject, newObject in
                        newObject?["soundRecordFile"] = nil;
                        newObject?["soundNote"] = ""
                    }
                }
            }
        Realm.Configuration.defaultConfiguration = config
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}


}

