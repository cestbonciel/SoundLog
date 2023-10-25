//
//  LocationService.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/10/12.
//

import CoreLocation
import Foundation

final class LocationService {
	static let shared = LocationService()
	var manager = CLLocationManager()
	var location: CLLocation?
	
	var convertedX = 0
	var convertedY = 0
	
	let locale = Locale(identifier: "Ko-kr")
	//MARK: Address
	var userRegion: String?
	var administrativeArea: String?
	var localityRegion: String?
	var subLocalityRegion: String?
	
	lazy var longitude: Double? = location?.coordinate.longitude
	lazy var latitude: Double? = location?.coordinate.latitude
	
	private init() {}
	
	func getLocation(location: CLLocation, completion: @escaping (CLLocation) -> Void) {
		manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		completion(location)
	}
	
	func locationToString(location: CLLocation, completion: @escaping () -> (Void)) {
		let geocoder = CLGeocoder()
		geocoder.reverseGeocodeLocation(location, preferredLocale: self.locale) { [weak self] placemarks, _ in
			guard let self = self,
						let placemarks = placemarks else { return }
			print("현재위치 : \(location)")
			
			if let locality = placemarks.last?.locality,
				 let sublocality = placemarks.last?.subLocality,
				 let administrative = placemarks.last?.administrativeArea {
				userRegion = locality + " " + sublocality
				localityRegion = locality
				subLocalityRegion = sublocality
				administrativeArea = administrative
				print("현재 주소 - 구 주소: \(String(describing: userRegion))")
			} else {
				if let administrative = placemarks.first?.administrativeArea,
					 let name = placemarks.first?.name {
					userRegion = administrative + " " + name
					administrativeArea = administrative
					print("도로명 주소 : \(String(describing: userRegion))")
				}
			}
			completion()
//
//			let convertedXy = LocationService.shared.convertGRID_GPS(lat_X: latitude ?? 0, lng_Y: longitude ?? 0)
//			convertedX = convertedXy.x
//			convertedY = convertedXy.y
//			print("converted: \(convertedX), \(convertedY)")
		}
	}
}
