//
//  BookmarkSoundLog.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/30.
//

import UIKit

import RealmSwift

class BookmarkSoundLog: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var soundLog: StorageSoundLog?
}

extension BookmarkSoundLog {
    static var realm = try! Realm()
    static func addBookmark(for soundLog: StorageSoundLog) {
        
        let bookmark = BookmarkSoundLog()
        bookmark.soundLog = soundLog
        
        try! realm.write {
            realm.add(bookmark)
        }
    }
    
    // 북마크 제거
    static func removeBookmark(for soundLog: StorageSoundLog) {
        if let bookmark = realm.objects(BookmarkSoundLog.self).filter("soundLog == %@", soundLog).first {
            try! realm.write {
                realm.delete(bookmark)
            }
        }
    }

    // 북마크 상태 확인
    static func isBookmarked(for soundLog: StorageSoundLog) -> Bool {
        let realm = try! Realm()
        return !realm.objects(BookmarkSoundLog.self).filter("soundLog == %@", soundLog).isEmpty
    }

}

