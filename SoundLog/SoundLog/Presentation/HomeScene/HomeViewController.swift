//
//  HomeViewController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/21.
//

import UIKit

class HomeViewController: UIViewController {

	
	@IBOutlet weak var monthlyArchive: UILabel!
	
	@IBOutlet weak var AddButton: UIButton!
	override func viewDidLoad() {
        super.viewDidLoad()

		
    }
    
	@IBAction func recordingSoundButtonTapped(_ sender: Any) {
		let viewController = RecordingSoundLogViewController()
		viewController.isModalInPresentation = true
		viewController.modalPresentationStyle = .fullScreen
		self.present(viewController, animated: true)
	}
//	recordingSound
	/*
	 @IBAction func actToOrange(_ sender: Any) {
		 if let orangeVC = self.storyboard?.instantiateViewController(identifier: "Orange") {
			 self.navigationController?.pushViewController(orangeVC, animated: true)
		 }
	 }
	 */
}
