//
//  RecordingSoundLogViewController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/24.
//

import UIKit
import SnapKit

class RecordingSoundLogViewController: UIViewController {
	
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.pastelSkyblue
		setupUI()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	//MARK: - Buttons: save, cancel
	private lazy var buttonStack: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [cancelButton, saveButton])
		stackView.frame = CGRect(x: 0, y: 0, width: 330, height: 40)
		stackView.axis = .horizontal
		stackView.alignment = .leading
		stackView.distribution = .equalSpacing
//		stackView.distribution = .fillEqually
		return stackView
	}()
	private lazy var cancelButton: UIButton = {
		let button = UIButton()
		button.frame = CGRect(x: 0, y: 0, width: 72, height: 40)
		button.layer.cornerRadius = 10
		button.setTitleColor(.black, for: .normal)
		button.backgroundColor = UIColor.systemDimGray
		button.setAttributedTitle(.attributeFont(font: .GMSansMedium, size: 16, text: "취소", lineHeight: 18), for: .normal)
	
		button.addTarget(self, action: #selector(actCancelButton), for: .touchUpInside)
		return button
	}()
	
	private lazy var saveButton: UIButton = {
		let button = UIButton()
		button.frame = CGRect(x: 0, y: 0, width: 72, height: 40)
		button.layer.cornerRadius = 10
		button.setTitleColor(.black, for: .normal)
		button.backgroundColor = UIColor.neonYellow
		button.setAttributedTitle(.attributeFont(font: .GMSansMedium, size: 16, text: "저장", lineHeight: 18), for: .normal)

		return button
	}()
	
	@objc func actCancelButton() {
//		self.dismiss(animated: true)
		UIView.animate(withDuration: 1.0, delay: 0.8, options: [.curveEaseInOut], animations: {
			self.dismiss(animated: true)
		}, completion: nil)
	}
//	@IBOutlet var moodButtons: [UIButton]!
//	var moodTag: Int = 1
//	@IBOutlet weak var characterLabel: UILabel!
//	@IBOutlet weak var searchTextField: UITextField!
//	@IBOutlet weak var recordTextView: UITextView!
	
//	@IBOutlet weak var viewGenreButton: UIButton!
	
	private func setupUI() {
		self.view.addSubview(buttonStack)
		buttonStack.snp.makeConstraints {
			$0.top.equalToSuperview().offset(80)
			$0.height.equalTo(40)
			$0.leading.equalToSuperview().offset(30)
			$0.trailing.equalToSuperview().offset(-30)
		}
		
//		buttonStack.addArrangedSubview(cancelButton)
		cancelButton.snp.makeConstraints {
			$0.leading.equalToSuperview()
			$0.width.equalTo(72)
			
		}
		saveButton.snp.makeConstraints {
			
			$0.trailing.equalToSuperview()
			$0.width.equalTo(72)

		}
		print("size:\(saveButton)")
	}
	

	
//	@IBAction func tappedSave(_ sender: UIButton) {
//		guard self.recordTextView.text?.isEmpty == true else {
//			let alert = UIAlertController(title: nil, message: "리뷰를 입력해주세요", preferredStyle: .alert)
//			alert.addAction(UIAlertAction(title: "OK", style: .default){_ in
//				self.navigationController?.popViewController(animated: true)
//			
//			})
//			self.present(alert, animated: true)
//			return
//		}
//	}
//	
//	@IBAction func selectGenreButton(_ sender: UIButton) {
////		let genreView = GenreTableViewController()
////		let nextView = self.storyboard!.instantiateViewController(withIdentifier: "genreView")
////		nextView.modalPresentationStyle = .fullScreen
////		present(nextView, animated: true)
//	}
//	
//	@IBAction func selectMood(_ sender: UIButton) {
//		moodButtons.forEach { mood in
//			mood.backgroundColor = .clear
//		}
//		
//		moodTag = sender.tag
//		sender.backgroundColor = UIColor.neonPurple
//		sender.layer.cornerRadius = sender.layer.frame.height / 2
//		sender.clipsToBounds = true
//	}
}
/*
extension RecordSoundLogViewController: UITextViewDelegate {
//	let placeholder = "오늘 당신의 음악을 기록해주세요."
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		//placeholder
		if recordTextView.text.isEmpty {
			recordTextView.text = placeholder
			recordTextView.textColor = .systemDimGray
			
		} else if recordTextView.text == placeholder {
			
			recordTextView.textColor = .black
			recordTextView.text = nil
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == placeholder {
			recordTextView.textColor = .gray
			recordTextView.text = placeholder
			characterLabel.textColor = .gray /// 텍스트 개수가 0일 경우에는 글자 수 표시 색상이 모두 gray 색이게 설정
			characterLabel.text = "0/400"
		}
	}
	
	func textViewDidChange(_ textView: UITextView) {
		if recordTextView.text.count > 400 {
			
			recordTextView.deleteBackward()
		}
		let lengthCharacter = recordTextView.text.count
		characterLabel.text = "\(lengthCharacter)/400"
		
		let attributedString = NSMutableAttributedString(string: "\(recordTextView.text.count)/400")
		attributedString.addAttribute(.foregroundColor, value: UIColor.black, range:  ("\(recordTextView.text.count)/400" as NSString).range(of:"\(recordTextView.text.count)"))
		characterLabel.attributedText = attributedString
	}

}

*/
