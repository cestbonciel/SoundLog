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
    //MARK: - 특정 id 기록 저장
    static func getSoundLogById(_ soundId: String) -> StorageSoundLog? {
        do {
            let realm = try Realm()
            return realm.object(ofType: StorageSoundLog.self, forPrimaryKey: soundId)
        } catch {
            print("Error accessing Realm: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func bringSoundId(_ soundId: String) -> StorageSoundLog? {
        return RealmManager.getSoundLogById(soundId)
    }
    
    static func getAllObjects() -> Results<StorageSoundLog> {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return realm.objects(StorageSoundLog.self)
    }
   
    static func editSoundLog(
        _ sound: StorageSoundLog,
        _ date: Date,
        _ soundTitle: String,
        _ soundMood: String,
        _ recordedFile: String,
        _ soundLocation: String,
        _ soundCategory: String
    ) {
        try! realm.write {
            sound.createdAt = date
            sound.soundTitle = soundTitle
            sound.soundMood = soundMood
            sound.recordedFileUrl = recordedFile
            sound.soundLocation = soundLocation
            sound.soundCategory = soundCategory
        }
    }
    
//    static func deleteObject<T: Object>(_ object: T) {
//        do {
//            try realm.write {
//                realm.delete(object)
//            }
//        } catch {
//            print("Error deleting object from Realm: \(error)")
//        }
//    }
    static func deleteSoundLog(_ sound: StorageSoundLog) {
        try! realm.write {
            realm.delete(sound)
        }
    }
    
}
