//
//  RecordSoundLogViewController.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/08/24.
//

import UIKit

class RecordSoundLogViewController: UIViewController {
	let placeholder = "오늘 당신의 음악을 기록해주세요."
	
	@IBOutlet var moodButtons: [UIButton]!
	var moodTag: Int = 1
	@IBOutlet weak var characterLabel: UILabel!
	@IBOutlet weak var searchTextField: UITextField!
	@IBOutlet weak var recordTextView: UITextView!
	
//	@IBOutlet weak var viewGenreButton: UIButton!
	
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

		
		
		
    }
    
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	@IBAction func tappedSave(_ sender: UIButton) {
		guard self.recordTextView.text?.isEmpty == true else {
			let alert = UIAlertController(title: nil, message: "리뷰를 입력해주세요", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default){_ in
				self.navigationController?.popViewController(animated: true)
			
			})
			self.present(alert, animated: true)
			return
		}
	}
	
	@IBAction func selectGenreButton(_ sender: UIButton) {
		let genreView = GenreTableViewController()
		let nextView = self.storyboard!.instantiateViewController(withIdentifier: "genreView")
		nextView.modalPresentationStyle = .fullScreen
		present(nextView, animated: true)
	}
	
	@IBAction func selectMood(_ sender: UIButton) {
		moodButtons.forEach { mood in
			mood.backgroundColor = .clear
		}
		
		moodTag = sender.tag
		sender.backgroundColor = UIColor.neonPurple
		sender.layer.cornerRadius = sender.layer.frame.height / 2
		sender.clipsToBounds = true
	}
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