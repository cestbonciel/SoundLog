//
//  StorageSoundLog.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/02/22.
//

import Foundation

import RealmSwift

final class RecordedFile: Object {
    @Persisted var recordedFileUrl: URL
}

final class StorageSoundLog: Object {
    @Persisted(primaryKey: true) var soundId: ObjectId
    @Persisted var createdAt: Date = Date()
    @Persisted var soundTitle: String = ""
    @Persisted var soundMood: String = ""
    @Persisted var recordedFileUrl: RecordedFile
    @Persisted var soundNote: String?
    @Persisted var soundLocation: String = ""
    @Persisted var soundCategory: String = "Recording"
}

extension StorageSoundLog {
    static var realm = try! Realm()
    /*
    static func saveObject(_ soundStorage: StorageSoundLog)  {
        do {
            try realm.write {
                realm.add(soundStorage)
            }
        } catch {
            print("Error saving object to Realm: \(error)")
        }
    }
    */
    static func saveRecordedFile(_ url: URL, completion: @escaping (Bool) -> Void) {
        let recordedFile = RecordedFile()
        recordedFile.recordedFileUrl = url.absoluteString
        do {
            try realm.write {
                realm.add(recordedFile)
                completion(true)
            }
        } catch {
            print("Error saving recorded file to Realm: \(error)")
            completion(false)
        }
    }
    
    static func saveObjectAllWithRecord(
        url: URL,
        title: String,
        mood: String,
        note: String?,
        location: String,
        category: String = "Recording",
        completion: @escaping (Bool) -> Void
    ) {
        guard let recordedFile = realm.objects(RecordedFile.self).filter("recordedFileUrl == %@", url.absoluteString).first else { return }
        let soundLog = StorageSoundLog()
        soundLog.createdAt = Date()
        soundLog.soundTitle = title
        soundLog.soundMood = mood
        soundLog.recordedFileUrl = recordedFile
        soundLog.soundNote = note
        soundLog.soundLocation = location
        soundLog.soundCategory = category
        do {
            try realm.write {
                realm.add(soundLog)
            }
            completion(true)
        } catch {
            print("Error saving soundLog object to Realm: \(error)")
            completion(false)
        }
    }
    
    static func printRealmFilePath() {
        print("Realm file path: \(Realm.Configuration.defaultConfiguration.fileURL!)")
    }

    static func getAllObjects() -> Results<StorageSoundLog> {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return realm.objects(StorageSoundLog.self)
    }
   
    static func editSoundLog(
        sound: StorageSoundLog,
        date: Date,
        soundTitle: String,
        soundMood: String,
        recordedFile: RecordedFile?,
        soundNote: String,
        soundLocation: String,
        soundCategory: String
    ) {
        try! realm.write {
            sound.createdAt = date
            sound.soundTitle = soundTitle
            sound.soundMood = soundMood
            sound.recordedFileUrl = recordedFile
            sound.soundNote = soundNote
            sound.soundLocation = soundLocation
            sound.soundCategory = soundCategory
        }
    }

    static func deleteSoundLog(_ sound: StorageSoundLog) {
        try! realm.write {
            realm.delete(sound)
        }
    }
    
    static func fetchDate(date: Date) -> Results<StorageSoundLog> {
        return realm.objects(StorageSoundLog.self).filter("createdAt >= %@ AND createdAt < %@", date, Date(timeInterval: 86400, since: date))
    }
}
