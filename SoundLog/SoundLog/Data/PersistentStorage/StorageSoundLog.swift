//
//  StorageSoundLog.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/02/22.
//

import Foundation

import RealmSwift

final class StorageSoundLog: Object {
    @Persisted(primaryKey: true) var soundId: String
    @Persisted var createdAt: Date
    @Persisted var soundTitle: String
    @Persisted var soundMood: String
    @Persisted var recordedFileUrl: String
    @Persisted var recordedSoundNote: String?
    @Persisted var soundLocation: String
    @Persisted var soundCategory: String

    convenience init(
        soundId: String,
        createdAt: Date,
        soundTitle: String,
        soundMood: String,
        recordedFileUrl: String,
        recordedSoundNote: String?,
        soundLocation: String,
        soundCategory: String
    ) {
        self.init()
        
        self.soundId = soundId
        self.createdAt = createdAt
        self.soundTitle = soundTitle
        self.soundMood = soundMood
        self.recordedFileUrl = recordedFileUrl
        self.recordedSoundNote = recordedSoundNote
        self.soundLocation = soundLocation
        self.soundCategory = soundCategory
    }
}
