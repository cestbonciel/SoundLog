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
    //Property 'soundRecordFile' is not a member type of 'StorageSoundLog'
    var soundLocation: Observable<String> = Observable("")
    var soundCategory: Observable<String> = Observable("")
    
    // MARK: - 1.제목 글자수 제한
    var titleLimitExceeded: Bool {
        return !(1...10).contains(soundTitle.value.count)
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
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    //2. 녹음 파일 포함해서 다른 요소들 같이 저장
    func create(completion: @escaping (Bool) -> Void) {
        
        guard let recordedFile = recordedFileUrl.value else {
            completion(false)
            return
        }

        StorageSoundLog.saveObjectWithRecord(
            createdAt: createdAt.value,
            recordFileUrl: recordedFile, // 직접 전달
            title: soundTitle.value,
            mood: soundMood.value,
            location: soundLocation.value,
            category: soundCategory.value
        ) { success in
            if success {
                print("SoundLogs successfully saved.")
                
                #if DEBUG
                StorageSoundLog.printRealmFilePath()
                #endif
            } else {
                print("Error: SoundLogs failed to save.")
            }
            completion(success)
        }
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

/*
 import UIKit

 class SoundLogViewModel {
     private var soundLogs: [StorageSoundLog] = Array(StorageSoundLog.getAllObjects())
     
     var createdAt: Observable<Date> = Observable(Date())
     var soundTitle: Observable<String> = Observable("")
     var soundMood: Observable<String> = Observable(MoodEmoji[0])
     var recordedFileUrl: Observable<RecordedFile?> = Observable(nil)
     //Cannot convert value of type 'RecordedFile.Type' to expected argument type 'RecordedFile'
     //var recordedSoundNote: Observable<String> = Observable("")
     var soundLocation: Observable<String> = Observable("")
     var soundCategory: Observable<String> = Observable("")
     
     var titlelimit: Bool {
         if soundTitle.value.isEmpty == false {
             if soundTitle.value.count >= 1 && soundTitle.value.count <= 7 {
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
     
 var moodIsValid: Bool {
     if soundMood.value.isEmpty {
          return false
     }
     return true
 }
 
     var soundIsValid: Bool {
         if let url = recordedFileUrl.value {
             //Initializer for conditional binding must have Optional type, not 'RecordedFile'
             return recordedFileUrl.value != nil
         } else {
             return false
         }
         //return recordedFileUrl.value != nil
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
     
     func create() {
         let newOne = StorageSoundLog()
         guard let recordedFile = recordedFileUrl.value,
               let url = URL(string: recordedFile.recordedFileUrl) else {
             //completion(false)
             return
         }
         newOne.createdAt = createdAt.value
         newOne.soundTitle = soundTitle.value
         newOne.soundMood = soundMood.value
         newOne.soundRecordFile = recordedFileUrl.value
         newOne.soundLocation = soundLocation.value
         newOne.soundCategory = soundCategory.value
         
         self.soundLogs.append(newOne)
         self.soundLogs.saveObjectWithRecord() 
     }
 
 //2. 녹음 파일 포함해서 다른 요소들 같이 저장
 func create() {
     
     guard let recordedFile = recordedFileUrl.value else { return }

     StorageSoundLog.saveObjectWithRecord(
         createdAt: createdAt.value,
         recordFileUrl: recordedFile, // 직접 전달
         title: soundTitle.value,
         mood: soundMood.value,
         location: soundLocation.value,
         category: soundCategory.value
     ) { success in
         if success {
             print("SoundLogs successfully saved.")
             #if DEBUG
             StorageSoundLog.printRealmFilePath()
             #endif
         } else {
             print("Error: SoundLogs failed to save.")
         }
     }
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


 
 */
