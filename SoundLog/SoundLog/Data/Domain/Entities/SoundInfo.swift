//
//  SoundInfo.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/02/23.
//

import Foundation

struct SoundInfo: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var createdAt: Date
    var soundTitle: String
    var soundMood: Int
    var recordedFileUrl: String
    var recordedSoundNote: String?
    var soundLocation: String
    var soundCategory: String
    /*
     soundTitle: String,
     soundMood: Int,
     recordedFileUrl: String,
     recordedSoundNote: String?,
     soundLocation: String,
     soundCategory: String
     */
}

extension SoundInfo {
    static let list = [
        
    ]
}
