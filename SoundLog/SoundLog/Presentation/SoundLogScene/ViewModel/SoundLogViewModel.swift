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
    var soundMood: Observable<String> = Observable(MoodEmoji[0])
    var recordedFileUrl: Observable<RecordedFile?> = Observable(nil)
  
    var soundLocation: Observable<String> = Observable("")
    var soundCategory: Observable<String> = Observable("")
    
    convenience init(log: StorageSoundLog) {
        self.init()
        self.soundLogs = [log]
        self.createdAt.value = log.createdAt
        self.soundTitle.value = log.soundTitle
        self.soundMood.value = log.soundMood
        self.recordedFileUrl.value = log.soundRecordFile
        self.soundCategory.value = log.soundCategory
    }
    
    // MARK: - 1.제목 글자수 제한
    var titleLimitExceeded: Bool {

        if soundTitle.value.isEmpty == false {
            if soundTitle.value.count <= 20 {
                return true
            } else {
                soundTitle.value.removeLast()
                return true
            }
        } else {
            
            return false
        }
    }
    
    
    
    // MARK: - 2.녹음파일 존재유무
    var soundIsValid: Bool {
        if let _ = recordedFileUrl.value {
            //Initializer for conditional binding must have Optional type, not 'RecordedFile'
            return recordedFileUrl.value != nil
        } else {
            return false
        }
    }
    // MARK: - 3. 위치 값 유무
    var locationIsValid: Bool {
        if soundLocation.value.isEmpty {
            return false
        }
        return true
    }
    
    // MARK: - 4. 감정 선택 유무
    var moodIsSelected: Bool {
        return !soundMood.value.isEmpty
    }
    // MARK: - 5. 카테고리 선택 유무
    var categoryIsValid: Bool {
        if soundCategory.value.isEmpty {
            return false
        }
        return true
    }

    func updateMood(with selectedIndex: Int) {
        soundMood.value = MoodEmoji[selectedIndex]
    }
    
    // MARK: - 1. 녹음파일 먼저 저장
    func createRecordedFile(url: URL, completion: @escaping (Bool) -> Void) {
        StorageSoundLog.saveRecordedFile(url) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    let recordedFile = StorageSoundLog.realm.objects(RecordedFile.self).filter("recordedFileUrl == %@", url.absoluteString).first
                    self?.recordedFileUrl.value = recordedFile
                    print(self?.recordedFileUrl.value)
                    print("recordedFile: \(recordedFile)")
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
        print("저장된 URL: \(url)")
    }
    
    //2. 녹음 파일 포함해서 다른 요소들 같이 저장
    func create() {
        let newOne = StorageSoundLog()
        guard let recordedFile = recordedFileUrl.value else {
            print("@@@: \(recordedFileUrl.value)")
            return
        }
        newOne.createdAt = createdAt.value
        newOne.soundTitle = soundTitle.value
        newOne.soundMood = soundMood.value
        newOne.soundRecordFile = recordedFileUrl.value
        newOne.soundLocation = soundLocation.value
        newOne.soundCategory = soundCategory.value

        self.soundLogs.append(newOne)
        StorageSoundLog.saveObjectWithRecord(newOne)
        print("기록: \(StorageSoundLog.saveObjectWithRecord(newOne))")
    }

    
    func edit(_ oldValue: StorageSoundLog) {
        //guard let recordedFile = recordedFileUrl.value else { return }
        StorageSoundLog.editSoundLog(
            sound: oldValue,
            date: createdAt.value,
            soundTitle: soundTitle.value,
            soundMood: soundMood.value,
            recordedFile: oldValue.soundRecordFile,
            soundLocation: oldValue.soundLocation,
            soundCategory: soundCategory.value
        )
    }
}
