//
//  MoodEmoji.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/13.
//

import UIKit

enum MoodEmoji: Int {
    case happy = 1, excited, sad, angry
    
     var emojiString: String {
        switch self {
        case .happy:
            return "😚"
        case .excited:
            return "🥳"
        case .sad:
            return "😢"
        case .angry:
            return "😡"
        }
    }
}

