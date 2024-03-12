//
//  SoundLogViewModel.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/13.
//

import UIKit

class SoundLogViewModel {
    private var sounds: [StorageSoundLog] = Array(RealmManager.getAllObjects())
    
    var createdAt: Observable<Date> = Observable(Date())
    var soundTitle: Observable<String> = Observable("")
    var soundMood: Observable<String> = Observable("😚")
    var recordedFileUrl: Observable<String?> = Observable(nil)
//    var recordedFileUrl: Observable<String> = Observable("")
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
    
    var moodIsValid: Bool {
        if soundMood.value.isEmpty {
             return false
        }
        return true
    }
    
    var soundIsValid: Bool {
        if let url = recordedFileUrl.value, !url.isEmpty {
            return true
        } else {
            return false
        }
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
    
    func createRecordedFile() -> RecordedFile? {
        guard let urlString = recordedFileUrl.value,
              !urlString.isEmpty else { return nil }
        let recordedFile = RecordedFile()
        recordedFile.recordedFileUrl = urlString
        return recordedFile
    }
    func create() {
        let newOne = StorageSoundLog()
        newOne.createdAt = createdAt.value
        newOne.soundTitle = soundTitle.value
        newOne.soundMood = soundMood.value
        newOne.recordedFileUrl = createRecordedFile()
        newOne.recordedSoundNote = recordedSoundNote.value
        newOne.soundLocation = soundLocation.value
        newOne.soundCategory = soundCategory.value
        
        self.sounds.append(newOne)
        RealmManager.saveObject(newOne)
    }
    
    func edit(_ oldValue: StorageSoundLog) {
        RealmManager.editSoundLog(
            sound: oldValue,
            date: createdAt.value,
            soundTitle: soundTitle.value,
            soundMood: soundMood.value,
            recordedFile: createRecordedFile(),
            soundNote: recordedSoundNote.value,
            soundLocation: soundLocation.value,
            soundCategory: soundCategory.value
        )
    }
}

