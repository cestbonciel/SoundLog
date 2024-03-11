//
//  CLPlackMark+Extension.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/12.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    var formattedAddress: String? {
        if let name = name, let locality = subLocality, let administrativeArea = administrativeArea {
            return "\(name), \(locality), \(administrativeArea)"
        }
        return nil
    }
}
