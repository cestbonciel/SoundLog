//
//  StartViewController.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/08/17.
//

import UIKit

class StartViewController: UIViewController {

	@IBOutlet weak var nicknameTextField: UITextField!
	@IBOutlet weak var appNamelabel: UILabel!
	
	@IBOutlet weak var startButton: UIButton!
	override func viewDidLoad() {
        super.viewDidLoad()
		self.changeTextColor()
		nicknameTextField.layer.borderWidth = 1
		nicknameTextField.layer.cornerRadius = 20
		startButton.layer.borderColor = UIColor.black.cgColor
		startButton.layer.borderWidth = 1
    }
    
	func changeTextColor() {
		guard let text = self.appNamelabel.text else { return }
		let attributeString = NSMutableAttributedString(string: text)
		attributeString.addAttribute(.foregroundColor, value: UIColor(displayP3Red: 149/255, green: 146/255, blue: 230/255, alpha: 1), range: (text as NSString).range(of: "오"))
		attributeString.addAttribute(.foregroundColor, value: UIColor(displayP3Red: 149/255, green: 146/255, blue: 230/255, alpha: 1), range: (text as NSString).range(of: "내"))
		attributeString.addAttribute(.foregroundColor, value: UIColor(displayP3Red: 149/255, green: 146/255, blue: 230/255, alpha: 1), range: (text as NSString).range(of: "악"))
		self.appNamelabel.attributedText = attributeString
		
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
