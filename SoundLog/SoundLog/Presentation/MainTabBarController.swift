//
//  MainTabBarController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/18.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {

	
	
//	let swiftUIswitch = UIHostingController(rootView: SettingView())
	@IBOutlet weak var AddTabBar: UITabBarItem!
	@IBOutlet weak var homeTabBar: UITabBar!
	override func viewDidLoad() {
        super.viewDidLoad()
		
		
    }
    
	func tappedAddTabBar(_ sending:UITabBarItem!) {
		
	}
	
//	@IBAction func goToSettingView(_ sender: Any) {
//		navigationController?.pushViewController(swiftUIswitch, animated: true)
//	}
	
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
