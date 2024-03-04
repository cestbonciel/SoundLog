//
//  RealmManager.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/02/22.
//

import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    private let realm: Realm
    
    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }
    
    func saveObject<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Error saving object to Realm: \(error)")
        }
    }
    //MARK: - 특정 id 기록 저장
    func getSoundLogById(_ soundId: String) -> StorageSoundLog? {
        do {
            let realm = try Realm()
            return realm.object(ofType: StorageSoundLog.self, forPrimaryKey: soundId)
        } catch {
            print("Error accessing Realm: \(error.localizedDescription)")
            return nil
        }
    }
    
    func bringSoundId(_ soundId: String) -> StorageSoundLog? {
        return RealmManager.shared.getSoundLogById(soundId)
    }
    
    func getAllObjects<T: Object>(_ objectType: T.Type) -> Results<T>? {
        return realm.objects(objectType)
    }
    
    func updateObject<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            print("Error updating object in Realm: \(error)")
        }
    }
    
    func deleteObject<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("Error deleting object from Realm: \(error)")
        }
    }
    
}
