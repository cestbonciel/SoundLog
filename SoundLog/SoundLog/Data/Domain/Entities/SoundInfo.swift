//
//  SoundInfo.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/02/23.
//

import Foundation

struct SoundInfo: Codable, Hashable, Identifiable {
    
    enum SoundCategory: String, Codable {
        case asmr = "ASMR"
        case recording = "Recording"
        // 다른 카테고리를 추가할 수 있습니다.
    }
    
    var id: String = UUID().uuidString
    var createdAt: Date
    var soundTitle: String
    var soundMood: String
    var recordedFileUrl: String
    var recordedSoundNote: String?
    var soundLocation: String
    var soundCategory: SoundCategory

}
// MARK: - Dummy Data
extension SoundInfo {
    static let list = [
        SoundInfo(
            id:"1",
            createdAt: Date(),
            soundTitle: "속초 바닷가 파도소리",
            soundMood: "😁",
            recordedFileUrl: "http://",
            soundLocation: "강릉 속초",
            soundCategory: .asmr
        ),
        SoundInfo(
            id:"2",
            createdAt: Date(),
            soundTitle: "지나가다 들은 버스킹하는 사람의 기타 연주",
            soundMood: "😄",
            recordedFileUrl: "http://",
            soundLocation: "강릉 속초",
            soundCategory: .recording
        )
    ]
}
