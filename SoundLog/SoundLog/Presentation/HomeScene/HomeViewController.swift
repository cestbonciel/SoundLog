//
//  HomeViewController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/21.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

	@IBOutlet weak var topSideStackView: UIStackView!
	@IBOutlet weak var monthlyArchive: UILabel!
	
	@IBOutlet weak var AddButton: UIButton!
	
	private lazy var calendarView: UICalendarView = {
		let calendarView = UICalendarView()
		let gregorianCalendar = Calendar(identifier: .gregorian)
		calendarView.calendar = gregorianCalendar
		calendarView.locale = Locale(identifier: "ko-KR")
		calendarView.fontDesign = .default
		return calendarView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupHomeUI()
	}
	
	@IBAction func recordingSoundButtonTapped(_ sender: Any) {
		let viewController = SoundLogViewController()
		viewController.isModalInPresentation = true
		viewController.modalPresentationStyle = .fullScreen
		self.present(viewController, animated: true)
	}
	
//	private lazy var calendarView = UICalendarView()
	private func setupHomeUI() {
		view.addSubview(topSideStackView)
		view.addSubview(calendarView)
		calendarView.translatesAutoresizingMaskIntoConstraints = false
		
		
	}
	
}
