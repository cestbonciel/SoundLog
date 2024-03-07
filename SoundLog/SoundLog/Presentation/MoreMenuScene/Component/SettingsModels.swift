//
//  SettingsModels.swift
//  SoundLog
//
//  Created by Nat Kim on 2023/12/15.
//

import Foundation

struct Section {
    //let title: String
    let options: [SettingsCellType]
}

enum SettingsCellType {
    case staticCell(model: SettingsOption)
}



struct SettingsOption {
    let title: String
    let handler: (() -> Void)
}
