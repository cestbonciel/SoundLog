//
//  MapViewController.swift
//  UserLocationAddress
//
//  Created by Seohyun Kim on 2023/10/19.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
	
	var locationManager = CLLocationManager()
	weak var mapDelegate: MapViewControllerDelegate?
    weak var viewModel: SoundLogViewModel!
	var currentLocationAddress: String?
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	private lazy var mapView: MKMapView = {
		let mapView = MKMapView()
		mapView.delegate = self
		mapView.translatesAutoresizingMaskIntoConstraints = false
		return mapView
	}()
	
	private lazy var confirmButton: UIButton = {
		var configuration = UIButton.Configuration.plain()
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        configuration.attributedTitle = AttributedString("확인", attributes: titleContainer)
		configuration.baseForegroundColor = .black
		configuration.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
		let button = UIButton(configuration: configuration)
        button.backgroundColor = .neonLightPurple
		button.layer.cornerRadius = 8
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(downPopViewButton), for: .touchUpInside)
		return button
	}()
	
	@objc func downPopViewButton() {
		self.mapDelegate?.dismissMapViewController()
	}
	
	private lazy var showUserLocationButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "location3"), for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(findMyLocation), for: .touchUpInside)
		return button
	}()
	
	@objc func findMyLocation() {
		guard let currentLocation = locationManager.location else {
			requestLocationPermission()
			return
		}
		mapView.showsUserLocation = true
		mapView.setUserTrackingMode(.follow, animated: true)
		
		let geocoder = CLGeocoder()
		geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
			if let placemark = placemarks?.first {
				if let address = placemark.formattedAddress {
                    self.viewModel.soundLocation.value = address
					self.mapDelegate?.didSelectLocationWithAddress(address)
				}
			}
		}
		
	}

	
	 func requestLocationPermission() {
		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		DispatchQueue.global(qos: .userInitiated).async {
			if CLLocationManager.locationServicesEnabled() {
				switch self.locationManager.authorizationStatus {
				case .authorizedAlways, .authorizedWhenInUse:
					// 위치 권한이 승인되어 있는 경우
					self.locationManager.startUpdatingLocation()
				case .notDetermined:
					// 위치 권한을 요청받지 않은 경우
					DispatchQueue.main.async {
						self.locationManager.requestAlwaysAuthorization()
					}
				case .denied, .restricted:
					// 위치 권한이 거부되거나 제한된 경우
					DispatchQueue.main.async {
						self.showLocationServicesDisabledAlert()
					}
					break
				default:
					break
				}
			} else {
				self.showLocationServicesDisabledAlert()
			}
		}
	}
	
	func showLocationServicesDisabledAlert() {
		
		let alertController = UIAlertController(
			title: "위치 권한 비활성화",
			message: "사용자만이 알 수 있는 위치 정보 이용입니다. 함께 기록하기 위해 정확한 위치를 켜야합니다. 설정으로 이동하시겠습니까?",
			preferredStyle: .alert
		)
		
		let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
		let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
			if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
				UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
			}
		}
		
		alertController.addAction(cancelAction)
		alertController.addAction(settingsAction)
		
		present(alertController, animated: true, completion: nil)
	}
	
	private func setupUI() {
		view.addSubview(mapView)
		view.addSubview(confirmButton)
		
		confirmButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
		confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
		
		view.addSubview(showUserLocationButton)
		mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
		mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
		mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		NSLayoutConstraint.activate([
			showUserLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
			showUserLocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
			showUserLocationButton.widthAnchor.constraint(equalToConstant: 40),
			showUserLocationButton.heightAnchor.constraint(equalToConstant: 40)
		])
		
	}
	
}


extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		// Default: blue circle
		guard !annotation.isKind(of: MKUserLocation.self) else {
			return nil
		}
		var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Custom")
		
		if annotationView == nil {
			annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Custom")
			annotationView?.canShowCallout = true
			
			let pin = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
			pin.setImage(UIImage(systemName: "figure.wave"), for: .normal)
			pin.tintColor = .systemPurple
			annotationView?.rightCalloutAccessoryView = pin
		} else {
			annotationView?.annotation = annotation
		}
		
		return annotationView
	}

	
}
