//
//  MoodEmoji.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/13.
//

import UIKit

/*
enum MoodEmoji: Int, CaseIterable {
    case none = 0, happy, excited, sad, angry
    
     var emojiString: String? {
        switch self {
        case .happy:
            return "😚"
        case .excited:
            return "🥳"
        case .sad:
            return "😢"
        case .angry:
            return "😡"
        case .none:
            return nil
        }
    }
}
*/

struct MoodEmoji {
    static let emojis: [String] = [
        "", // 기분 선택을 위한 빈 문자열(선택하지 않음을 나타냄)
        "😚", // happy
        "🥳", // excited
        "😢", // sad
        "😡"  // angry
        // 여기에 추가 이모지를 계속 넣을 수 있습니다.
    ]
    
    static subscript(index: Int) -> String {
        guard emojis.indices.contains(index) else { return "" }
        return emojis[index]
    }
}
