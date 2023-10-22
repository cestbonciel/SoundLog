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
	
	var calendarDelegate: CalendarDelegate!
	var selectedDate: DateComponents? = nil
	
	@IBOutlet weak var AddButton: UIButton!
	
	private lazy var calendarView: UICalendarView = {
		let calendarView = UICalendarView()
		calendarView.translatesAutoresizingMaskIntoConstraints = false
		let gregorianCalendar = Calendar(identifier: .gregorian)
		calendarView.calendar = gregorianCalendar
		calendarView.locale = Locale(identifier: "ko-KR")
		calendarView.fontDesign = .rounded
		calendarView.tintColor = .neonPurple
		
		calendarView.visibleDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 10, day: 7)
		calendarView.wantsDateDecorations = true
		return calendarView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		setCalendarView()
		setupHomeUI()
		setupCalendar()
//		reloadDateView(date: Date())
//		calendarView.delegate = calendarDelegate
		calendarDelegate = CalendarDelegate()
		calendarView.delegate = calendarDelegate
	}
	
//	fileprivate func setCalendarView() {
//
//		let dateSelection = UICalendarSelectionSingleDate(delegate: self)
//		calendarView.selectionBehavior = dateSelection
//	}
	
	func setupCalendar() {
		let multiDaySelection = UICalendarSelectionMultiDate(delegate: self)
		multiDaySelection.selectedDates = SoundDateDatabase.shared.selectedDate ?? []
		calendarView.selectionBehavior = multiDaySelection
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
		
		calendarView.snp.makeConstraints {
			$0.top.equalTo(topSideStackView.snp.bottom).offset(20)
			$0.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
			$0.height.equalTo(400)
		}
		
	}
	
//	func reloadDateView(date: Date?) {
//		if date == nil { return }
//		let calendar = Calendar.current
//		calendarView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date!)], animated: true)
//	}
	
}

extension HomeViewController: UICalendarSelectionMultiDateDelegate {
	func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
			
	}
	
	func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
		
	}
//	func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canSelectDate dateComponents: DateComponents) -> Bool {
//		return !DateDatabase.shared.grayedOutDates.compactMap({ $0.date}).contains(dateComponents.date)
//	}
}
//extension HomeViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
//
//	func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
//		if let selectedDate = selectedDate, selectedDate == dateComponents {
//			return .customView {
//				let label = UILabel()
//				label.text = "•"
//				label.textColor = UIColor.magenta
//				label.textAlignment = .center
//				return label
//			}
//		}
//		return nil
//
//	}
//
//
//	// when date is selected on calendar
//	func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
//		selection.setSelected(dateComponents, animated: true)
//		selectedDate = dateComponents
//		reloadDateView(date: Calendar.current.date(from: dateComponents!))
//	}
//
//
//}
