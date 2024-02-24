//
//  SoundInfo.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/02/23.
//

import Foundation

struct SoundInfo: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var createdAt: String
    var soundTitle: String
    var soundMood: Int
    var recordedFileUrl: String
    var recordedSoundNote: String?
    var soundLocation: String
    var soundCategory: String
    /*
     soundTitle: String,
     soundMood: Int,
     recordedFileUrl: String,
     recordedSoundNote: String?,
     soundLocation: String,
     soundCategory: String
     */
    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "id": id,
            "createdAt": createdAt,
            "soundTitle": soundTitle,
            "soundMood": soundMood,
            "recordedFileUrl": recordedFileUrl,
            "recordedSoundNote": recordedSoundNote ?? "내용 없음",
            "soundLocation": soundLocation,
            "soundCategory": soundCategory
        ]
        return dict
    }
}

extension Array where Element == SoundInfo {
    func indexOfProduct(with id: SoundInfo.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

extension SoundInfo {
    static let list = [
        SoundInfo(
            id:"1",
            createdAt: "2024-02-24",
            soundTitle: "속초 바닷가 파도소리",
            soundMood: 2,
            recordedFileUrl: "http://",
            soundLocation: "강릉 속초",
            soundCategory: "ASMR"
        ),
        SoundInfo(
            id:"1",
            createdAt: "2024-02-24",
            soundTitle: "속초 바닷가 파도소리",
            soundMood: 2,
            recordedFileUrl: "http://",
            soundLocation: "강릉 속초",
            soundCategory: "ASMR"
        )
    ]
}
