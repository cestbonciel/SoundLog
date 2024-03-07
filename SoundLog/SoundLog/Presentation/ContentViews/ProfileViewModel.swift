//
//  ProfileViewModel.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/08.
//

import Foundation

struct ProfileViewModel {
    var username: String?
    
    var nameIsValid: Bool {
        return username?.isEmpty == false && username!.count < 9
    }
    var usernameValidationLabelText: String {
        return nameIsValid ? "" : "1글자이상 8글자 이하로 입력해주세요."
    }
    
}
