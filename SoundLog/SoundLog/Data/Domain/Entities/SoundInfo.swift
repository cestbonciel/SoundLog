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
    var soundMood: String
    var recordedFileUrl: String
    var recordedSoundNote: String?
    var soundLocation: String
    var soundCategory: String

}

extension SoundInfo {
    static let list = [
        SoundInfo(
            id:"1",
            createdAt: "2024-02-24",
            soundTitle: "속초 바닷가 파도소리",
            soundMood: "😁",
            recordedFileUrl: "http://",
            soundLocation: "강릉 속초",
            soundCategory: "ASMR"
        ),
        SoundInfo(
            id:"2",
            createdAt: "2024-02-24",
            soundTitle: "속초 바닷가 파도소리",
            soundMood: "😡",
            recordedFileUrl: "http://",
            soundLocation: "강릉 속초",
            soundCategory: "ASMR"
        )
    ]
}
