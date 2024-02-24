//
//  SoundInfoManager.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/02/24.
//

import UIKit

class SoundInfoManager {
    var sounds: [SoundInfo] = []
    
    

    func createSound() -> SoundInfo {
        let today = Date.now.stringFormat
        return SoundInfo(createdAt: today, soundTitle: "", soundMood: 2, recordedFileUrl: "", soundLocation: "", soundCategory: "")
    }
}

extension Date {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    var stringFormat: String {
        return Date.dateFormatter.string(from: self)
    }
}
