//
//  StorageSoundLog.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/02/22.
//

import Foundation

import RealmSwift

final class RecordedFile: Object {
    @Persisted var recordedFileUrl: String
}

final class StorageSoundLog: Object {
    @Persisted(primaryKey: true) var soundId: ObjectId
    @Persisted var createdAt: Date
    @Persisted var soundTitle: String
    @Persisted var soundMood: String
    @Persisted var recordedFileUrl: RecordedFile?
    @Persisted var recordedSoundNote: String?
    @Persisted var soundLocation: String
    @Persisted var soundCategory: String

    convenience init(
        createdAt: Date,
        soundTitle: String,
        soundMood: String,
        recordedFileUrl: RecordedFile?,
        recordedSoundNote: String?,
        soundLocation: String,
        soundCategory: String
    ) {
        self.init()
        
        self.createdAt = createdAt
        self.soundTitle = soundTitle
        self.soundMood = soundMood
        self.recordedFileUrl = recordedFileUrl
        self.recordedSoundNote = recordedSoundNote
        self.soundLocation = soundLocation
        self.soundCategory = soundCategory
    }
}
