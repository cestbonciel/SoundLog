//
//  RealmManager.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/02/22.
//

import Foundation
import RealmSwift

final class RealmManager {
    static var realm = try! Realm()
 
    static func saveObject(_ soundStorage: StorageSoundLog)  {
        do {
            try realm.write {
                realm.add(soundStorage)
            }
        } catch {
            print("Error saving object to Realm: \(error)")
        }
    }
    
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
            sound.recordedSoundNote = soundNote
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
        return realm.objects(StorageSoundLog.self).filter("date >= %@ AND date < %@", Date(timeInterval: 86400, since: date))
    }
    
}
