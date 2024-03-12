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
        formatter.amSymbol = "a.m."
        formatter.pmSymbol = "p.m."
        return formatter
    }()
    
    var toTimeString: String {
        return Date.timeFormatter.string(from: self)
    }
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    var stringFormat: String {
        return Date.dateFormatter.string(from: self)
    }
    
    static var dateFormatterShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd."
        return formatter
    }()
    
    var stringFormatShort: String {
        return Date.dateFormatterShort.string(from: self)
    }
}
