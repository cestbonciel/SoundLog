//
//  SoundLogViewModel.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/13.
//

import UIKit

class SoundLogViewModel {
    private var soundLogs: [StorageSoundLog] = Array(StorageSoundLog.getAllObjects())
    
    var createdAt: Observable<Date> = Observable(Date())
    var soundTitle: Observable<String> = Observable("")
    var soundMood: Observable<String> = Observable(MoodEmoji[1])
    //var recordedFileUrl: Observable<String?> = Observable(nil)
    var recordedFileUrl: Observable<RecordedFile?> = Observable(nil)
    //Cannot convert value of type 'RecordedFile.Type' to expected argument type 'RecordedFile'
    var recordedSoundNote: Observable<String> = Observable("")
    var soundLocation: Observable<String> = Observable("")
    var soundCategory: Observable<String> = Observable("Recording")
    
    var titlelimit: Bool {
        if soundTitle.value.isEmpty == false {
            if soundTitle.value.count >= 3 && soundTitle.value.count <= 7 {
                return true
            } else {
                soundTitle.value.removeLast()
                return true
            }
        } else {
            return false
        }
    }
    
    var titleLimitExceeded: Bool {
        return !(1...10).contains(soundTitle.value.count)
    }
    
//    var moodIsValid: Bool {
//        if soundMood.value.isEmpty {
//            // Value of type 'MoodEmoji' has no member 'isEmpty'
//             return false
//        }
//        return true
//    }
    
    var soundIsValid: Bool {
        /*
        if let url = recordedFileUrl.value {
            //Initializer for conditional binding must have Optional type, not 'RecordedFile'
            return recordedFileUrl.value != nil
        } else {
            return false
        }
        */
        return recordedFileUrl.value != nil
    }
    
    var locationIsValid: Bool {
        if soundLocation.value.isEmpty {
            return false
        }
        return true

    }
    
    var categoryIsValid: Bool {
        if soundCategory.value.isEmpty {
            return false
        }
        return true
    }
    /*
    func createRecordedFile() -> RecordedFile? {
        guard let urlString = recordedFileUrl.value,
              !urlString.isEmpty else { return nil }
        let recordedFile = RecordedFile()
        recordedFile.recordedFileUrl = urlString
        return recordedFile
    }
    */
    
    func updateMood(with selectedIndex: Int) {
        soundMood.value = MoodEmoji[selectedIndex]
    }
    
    func createRecordedFile(url: URL, completion: @escaping (Bool) -> Void) {
        StorageSoundLog.saveRecordedFile(url) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    // 저장된 RecordedFile 객체를 찾아서 recordedFileUrl에 할당
                    let recordedFile = StorageSoundLog.realm.objects(RecordedFile.self).filter("recordedFileUrl == %@", url.absoluteString).first
                    self?.recordedFileUrl.value = recordedFile
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func create(completion: @escaping (Bool) -> Void) {
        let newOne = StorageSoundLog()
        guard let recordedFile = recordedFileUrl.value,
              let urlString = URL(string: recordedFile.recordedFileUrl) else {
            completion(false)
            return
        }
        
        self.soundLogs.append(newOne)
        StorageSoundLog.saveObjectWithRecord(newOne)
        /*
        StorageSoundLog.saveObjectAllWithRecord(
            url: urlString, // URL 객체를 사용합니다.
            title: soundTitle.value,
            mood: soundMood.value,
            note: recordedSoundNote.value,
            location: soundLocation.value,
            category: soundCategory.value,
            completion: completion
        )
        */
    }
    
    func edit(_ oldValue: StorageSoundLog) {
        guard let recordedFile = recordedFileUrl.value else { return }
        StorageSoundLog.editSoundLog(
            sound: oldValue,
            date: createdAt.value,
            soundTitle: soundTitle.value,
            soundMood: soundMood.value,
            recordedFile: oldValue.soundRecordFile,
            // Value of type 'StorageSoundLog' has no member 'recordedFileUrl'
            soundNote: recordedSoundNote.value,
            soundLocation: oldValue.soundLocation,
            soundCategory: soundCategory.value
        )
    }
}

