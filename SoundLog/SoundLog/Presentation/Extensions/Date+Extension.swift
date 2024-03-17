//
//  Date+Extension.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/13.
//

import Foundation

extension Date {
    private static var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US")
        //formatter.locale = Locale(identifier: "ko_KR")
        formatter.amSymbol = "a.m."
        formatter.pmSymbol = "p.m."
        return formatter
    }()
    
    var toTimeString: String {
        return Date.timeFormatter.string(from: self)
    }
}
