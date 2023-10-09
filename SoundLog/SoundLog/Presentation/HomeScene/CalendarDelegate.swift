//
//  CalendarDelegate.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/10/10.
//

import UIKit

class CalendarDelegate: NSObject,UICalendarViewDelegate {
	func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
		return DateDatabase.shared.eventOnCalendar(date: dateComponents)
	}
	/*
	 func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
		 if let selectedDate = selectedDate, selectedDate == dateComponents {
			 return .customView {
				 let label = UILabel()
				 label.text = "•"
				 label.textColor = UIColor.magenta
				 label.textAlignment = .center
				 return label
			 }
		 }
		 return nil
		 
	 }
	 
	 */
}
