//
//  Date+Extension.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/13.
//

import Foundation

extension Date {
    static var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US")
        //formatter.locale = Locale(identifier: "ko_KR")
        formatter.amSymbol = "a.m"
        formatter.pmSymbol = "p.m"
        return formatter
    }()
    
    static var recordDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMddHHmm"
//        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    var toTimeString: String {
        return Date.timeFormatter.string(from: self)
    }
    
    var toRecordTimeString: String {
        return Date.recordDateFormatter.string(from: self)
    }
}
