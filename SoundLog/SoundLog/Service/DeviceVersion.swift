//
//  DeviceVersion.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/07.
//

import UIKit

class Device {
    static func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    static func getBuildVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
    
    static func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
    
    static func getDeviceModelName() -> String {
        let device = UIDevice.current
        let selectName = "_\("deviceInfo")ForKey:"
        let selector = NSSelectorFromString(selectName)
        
        if device.responds(to: selector) {
            let modelName = String(describing: device.perform(selector, with: "marketing-name").takeRetainedValue())
            return modelName
        }
        return "알 수 없음"
    }
}
