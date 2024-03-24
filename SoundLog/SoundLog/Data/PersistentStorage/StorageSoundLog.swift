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
    @Persisted(primaryKey: true) var _soundId: ObjectId
    @Persisted var createdAt: Date = Date()
    @Persisted var soundTitle: String = ""
    @Persisted var soundMood: String = ""
    @Persisted var soundRecordFile: RecordedFile?
    @Persisted var soundLocation: String = ""
    @Persisted var soundCategory: String = ""
}

extension StorageSoundLog {
   
    static var realm = try! Realm()
    static func getAllObjects() -> Results<StorageSoundLog> {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return realm.objects(StorageSoundLog.self)
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

    
    static func saveObjectWithRecord(
        createdAt: Date,
        recordFileUrl: RecordedFile,
        title: String,
        mood: String,
        location: String,
        category: String = "Recording",
        completion: @escaping (Bool) -> Void
    ) {
        let realm = try! Realm()
        let soundLog = StorageSoundLog()
        soundLog.createdAt = createdAt
        soundLog.soundTitle = title
        soundLog.soundMood = mood
        soundLog.soundRecordFile = recordFileUrl
        soundLog.soundLocation = location
        soundLog.soundCategory = category
        do {
            try realm.write {
                realm.add(soundLog)
                completion(true)
            }
        } catch {
            print("Error saving soundLog object to Realm: \(error.localizedDescription)")
            completion(false)
        }
    }
   
    static func printRealmFilePath() {
        print("Realm file path: \(Realm.Configuration.defaultConfiguration.fileURL!)")
    }

    static func editSoundLog(
        sound: StorageSoundLog,
        date: Date,
        soundTitle: String,
        soundMood: String,
        recordedFile: RecordedFile?,
        //soundNote: String,
        soundLocation: String,
        soundCategory: String
    ) {
        try! realm.write {
            sound.createdAt = date
            sound.soundTitle = soundTitle
            sound.soundMood = soundMood
            sound.soundRecordFile = recordedFile
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


/*
 import Foundation

 import RealmSwift


 final class RecordedFile: Object {
     @Persisted var recordedFileUrl: String
 }

 final class StorageSoundLog: Object {
     @Persisted(primaryKey: true) var _soundId: ObjectId
     @Persisted var createdAt: Date = Date()
     @Persisted var soundTitle: String = ""
     @Persisted var soundMood: String = ""
     @Persisted var soundRecordFile: RecordedFile?
     //@Persisted var soundNote: String?
     @Persisted var soundLocation: String = ""
     @Persisted var soundCategory: String = ""
 }

 extension StorageSoundLog {
    
     static var realm = try! Realm()
     static func getAllObjects() -> Results<StorageSoundLog> {
         print(Realm.Configuration.defaultConfiguration.fileURL!)
         return realm.objects(StorageSoundLog.self)
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
 
     static func saveObjectWithRecord(_ soundLogs: StorageSoundLog) {
         do {
             try realm.write {
                 realm.add(soundLogs)
             }
         } catch {
             print("Error saving soundLog object to Realm: \(error)")
         }
     }
     
     
     static func saveObjectWithRecord(
         createdAt: Date,
         url: URL,
         title: String,
         mood: String,
         location: String,
         category: String = "Recording",
         completion: @escaping (Bool) -> Void
     ) {
         guard let recordedFile = realm.objects(RecordedFile.self).filter("recordedFileUrl == %@", url.absoluteString).first else { return }
         let soundLog = StorageSoundLog()
         soundLog.createdAt = Date()
         soundLog.soundTitle = title
         soundLog.soundMood = mood
         soundLog.soundRecordFile = recordedFile
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

     static func editSoundLog(
         sound: StorageSoundLog,
         date: Date,
         soundTitle: String,
         soundMood: String,
         recordedFile: RecordedFile?,
         //soundNote: String,
         soundLocation: String,
         soundCategory: String
     ) {
         try! realm.write {
             sound.createdAt = date
             sound.soundTitle = soundTitle
             sound.soundMood = soundMood
             sound.soundRecordFile = recordedFile
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

 
 */
