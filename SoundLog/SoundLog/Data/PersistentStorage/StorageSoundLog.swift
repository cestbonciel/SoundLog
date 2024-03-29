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
    //@Persisted var soundLocation: SoundLogSpot
    @Persisted var soundCategory: String = ""
}

extension StorageSoundLog {
   
    static var realm = try! Realm()
    // MARK: - 조회
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
                print("새 녹음 정보가 성공적으로 저장되었습니다. \(recordedFile)")
                completion(true)
            }
        } catch {
            print("Error saving recorded file to Realm: \(error)")
            completion(false)
        }
    }
    
    // MARK: - Save
    static func saveObjectWithRecord(_ soundLogs: StorageSoundLog) {
        do {
            try realm.write {
                realm.add(soundLogs)
                print("새 녹음일기 정보가 성공적으로 저장되었습니다. \(soundLogs)")
            }
        } catch {
            print("Error saving soundLog object to Realm: \(error)")
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
        //soundLocation: SoundLogSpot,
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

//    var isBookmarked: Bool {
//        return !(realm?.objects(BookmarkSoundLog.self).filter("soundLog == %@", self).isEmpty ?? true)
//    }
