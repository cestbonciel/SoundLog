//
//  DateDatabase.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/10/10.
//

import UIKit

class SoundDateDatabase {
	
	enum EventType {
		case none, recordingSound, shazam, asmr
	}
	
	public static let shared: SoundDateDatabase = SoundDateDatabase()
	
	private init() {
		
	}
	
	let selectedDate: [DateComponents]? = nil
	
//	let selectedDate: [DateComponents] = {
//		var date: [DateComponents] = []
//		date.append(DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 10, day: 15))
//		date.append(DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 10, day: 22))
//		date.append(DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 10, day: 23))
//		date.append(DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 10, day: 27))
//		date.append(DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 10, day: 29))
//		return date
//	}()
	
	let grayedOutDates: [DateComponents] = {
		
		var dates: [DateComponents] = []
		
		dates.append(DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 10, day: 12))
		dates.append(DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 10, day: 20))
		dates.append(DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 10, day: 25))
		return dates
	}()
	
	let dateEvents: [DateComponents : SoundDateDatabase.EventType] = [
		DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 10, day: 13): .recordingSound,
		DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 10, day: 15): .asmr,
		DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 10, day: 16): .asmr,
		DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 10, day: 24): .shazam,
		DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 10, day: 25): .shazam,
		DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 10, day: 26): .shazam,
	]
	
	private func eventStatus(date: DateComponents) -> SoundDateDatabase.EventType {
		if let component = dateEvents.filter({ $0.0.date == date.date }).first {
			return component.1
		}
		return .none
	}
	/*
	func eventOnCalendar(date: DateComponents) -> UICalendarView.Decoration? {
		let event = eventStatus(date: date)
		
		switch event {
		case .none:
			return nil
		case .recordingSound:
			
			return .customView {
				let label = UILabel()
				label.text = "𝗥"
				label.textColor = UIColor.systemRed
				label.textAlignment = .center
				return label
			}
			
		case .shazam:
			return .customView {
				let label = UILabel()
				label.text = "👂"
				label.textColor = UIColor.systemBlue
				label.textAlignment = .center
				return label
			}
		case .asmr:
			return .customView {
				let label = UILabel()
				label.text = "🍃"
				label.textColor = UIColor.systemBlue
				label.textAlignment = .center
				return label
			}
		}
		
	}
	*/
}
