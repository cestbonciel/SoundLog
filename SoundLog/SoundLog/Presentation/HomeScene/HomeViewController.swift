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
    
	@IBAction func recordingSound(_ sender: Any) {
		let targetStoryboard = UIStoryboard(name: "RecordingSound", bundle: nil)
		let targetViewController = targetStoryboard.instantiateViewController(withIdentifier: "Record")
		targetViewController.modalPresentationStyle = .fullScreen
		self.present(targetViewController, animated: true)
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
