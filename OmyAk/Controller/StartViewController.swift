//
//  StartViewController.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/08/17.
//

import UIKit

class StartViewController: UIViewController {
	var userNickname: String?
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
	
	@IBAction func inputNicknameInfo(_ sender: UIButton) {
		guard let input = nicknameTextField.text else { return }
		let inputLength = input.count
		if (3...7).contains(inputLength) {
			UserDefaults.standard.setValue(input, forKey: "nickname")
			userNickname = UUID().uuidString
			UserDefaults.standard.setValue(userNickname, forKey: "user_nickname")
			
			self.dismiss(animated: true)
		} else {
			let alert = UIAlertController(title: "닉네임 입력", message: "닉네임을 3자이상 7자 이내로 작성하세요.", preferredStyle: .alert)
			let action = UIAlertAction(title: "입려", style: .default) { _ in
				print("닉네임 정보가 저장되었습니다.") }
			alert.addAction(action)
			present(alert, animated: true)
		}
		
		let tabBarVC = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "tabBar")
		tabBarVC.modalPresentationStyle = .fullScreen
		present(tabBarVC, animated: true)
	}

}
