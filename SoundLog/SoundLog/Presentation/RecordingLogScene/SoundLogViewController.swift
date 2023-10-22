//
//  RecordingSoundLogViewController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/24.
//

import UIKit
import SnapKit
import CoreLocation

class SoundLogViewController: UIViewController, CLLocationManagerDelegate {
	private let soundLogTextView = LogTextView()
	
	//MARK: - CLLocation
	let locationManager = CLLocationManager()
	var isShowingLocation = true
	
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.pastelSkyblue
		setupUI()
		
		navigationController?.hidesBarsOnSwipe = true
		
		
	}
	

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	// MARK: - 위치정보
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			let geocoder = CLGeocoder()
			geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
				if let placemark = placemarks?.first {
					if let address = placemark.formattedAddress {
						self.addressLabel.text = "지금 여기\(address)"
					}
				}
			}
		}
	}
	
	// 위도 경도 받아오기 에러
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription)
	}

	@objc func toggleView() {
		if isShowingLocation {
			// Check if location services are authorized
			switch locationManager.authorizationStatus {
			case .authorizedWhenInUse, .authorizedAlways:
				// Location services are already authorized
				locationLabel.isHidden = true
				coreLocationButton.isHidden = true
				addressLabel.isHidden = false
				
				// Start updating location to get the current address
				locationLabel.text = "Fetching address..."
				locationManager.startUpdatingLocation()
			case .notDetermined:
				// Request location authorization asynchronously
				requestLocationAuthorization()
			case .denied, .restricted:
				// Show an alert to inform the user to enable location services in settings
				showLocationServicesDisabledAlert()
			@unknown default:
				break
			}
		} else {
			locationLabel.isHidden = false
			coreLocationButton.isHidden = false
			addressLabel.isHidden = true
			
			// Stop updating location when not needed
			locationManager.stopUpdatingLocation()
		}
		
		isShowingLocation = !isShowingLocation
	}
	
	func requestLocationAuthorization() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		locationManager.requestWhenInUseAuthorization()
	}
	
	func showLocationServicesDisabledAlert() {
		
		let alertController = UIAlertController(
			title: "위치 권한 비활성화",
			message: "위치 정보를 사용하려면 설정에서 위치 서비스를 활성화해야 합니다. 설정으로 이동하시겠습니까?",
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
	
	
	//MARK: - Entire View Scroll
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		//		scrollView.backgroundColor = .cyan
		//		scrollView.showsHorizontalScrollIndicator = false
		scrollView.showsVerticalScrollIndicator = true
		return scrollView
	}()
	
	private lazy var contentView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	//MARK: - Buttons: save, cancel
	private lazy var buttonStack: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [cancelButton, saveButton])
		stackView.axis = .horizontal
		stackView.alignment = .leading
		stackView.distribution = .equalSpacing
		return stackView
	}()
	private lazy var cancelButton: UIButton = {
		let button = UIButton()
		button.frame = CGRect(x: 0, y: 0, width: 72, height: 40)
		button.layer.cornerRadius = 10
		button.setTitleColor(.black, for: .normal)
		button.backgroundColor = UIColor.lightGray
		button.setAttributedTitle(.attributeFont(font: .GMSansMedium, size: 16, text: "취소", lineHeight: 18), for: .normal)
		
		button.addTarget(self, action: #selector(actCancelButton), for: .touchUpInside)
		return button
	}()
	
	private lazy var saveButton: UIButton = {
		let button = UIButton()
		button.frame = CGRect(x: 0, y: 0, width: 72, height: 40)
		button.layer.cornerRadius = 10
		button.setTitleColor(.black, for: .normal)
		button.backgroundColor = UIColor.neonYellow
		button.setAttributedTitle(.attributeFont(font: .GMSansBold, size: 16, text: "저장", lineHeight: 18), for: .normal)
		
		return button
	}()
	
	// MARK: - Common background  ( 나중에 컴포넌트화 하자)
	private lazy var backgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(white: 1, alpha: 0.5)
		view.layer.cornerRadius = 10
		view.clipsToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var date: UIDatePicker = {
		let datePicker = UIDatePicker()
		datePicker.datePickerMode = .dateAndTime
		if #available(iOS 14.0, *) {
			datePicker.preferredDatePickerStyle = .automatic
		} else {
			datePicker.preferredDatePickerStyle = .wheels
		}
		return datePicker
	}()
	
	@objc func actCancelButton() {
		
		let alertController = UIAlertController(title: "안내", message: "취소하면 작성한 내용이 사라집니다.", preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
		let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
			UIView.animate(withDuration: 1.0, delay: 0.8, options: [.curveEaseInOut], animations: {
				self.dismiss(animated: true)
			}, completion: nil)

		}
		alertController.addAction(cancelAction)
		alertController.addAction(confirmAction)

		present(alertController, animated: true, completion: nil)
		
	} 
	// MARK: - Diary Forms
	private lazy var titleTextField: UITextField = {
		let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 48))
		
		
		let leftInsetView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 48))
		textField.leftView = leftInsetView
		textField.leftViewMode = .always
		
		textField.attributedPlaceholder = .attributeFont(font: .GMSansMedium, size: 16, text: "제목 - 3자 이상 7자 미만.", lineHeight: 48)
		
		textField.layer.cornerRadius = 10
		textField.clearButtonMode = .whileEditing
		textField.autocorrectionType = .no
		textField.spellCheckingType = .no
		textField.autocapitalizationType = .none
		
		textField.returnKeyType = .done
		textField.delegate = self
		textField.layer.backgroundColor = UIColor.white.cgColor
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	private lazy var backgroundView2: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(white: 1, alpha: 0.5)
		view.layer.cornerRadius = 10
		view.clipsToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	//MARK: - Choose mood
	private lazy var moodStackView: UIStackView = {
		let stackView = UIStackView()
//		stackView.layer.borderWidth = 1    
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private lazy var moodButtons: [UIButton] = {
		var buttons = [UIButton]()
		let mood = [1: "기분", 2: "😚", 3: "😡", 4: "😢", 5: "🥳"]
		for (index, moodText) in mood.sorted(by: {  $0.key < $1.key }) {
			let button = UIButton()
			button.tag = index
			button.setTitle("\(moodText)", for: .normal)
			button.setTitleColor(.black, for: .normal)
			button.translatesAutoresizingMaskIntoConstraints = false
			button.addTarget(self, action: #selector(selectMood), for: .touchUpInside)
			
			if index == 1 {
				if let customFont = UIFont(name: "GmarketSansMedium", size: 16.0) {
					// Apply the custom font to the button's title label
					button.titleLabel?.font = customFont
				} else {
					// Fallback to a system font if the custom font is not available
					button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
				}
			}
			
			buttons.append(button)
		}
		
		if let firstButton = buttons.first {
			firstButton.isEnabled = false
			
		}
		
		return buttons
	}()
	
	@objc private func selectMood(_ sender: UIButton) {
		var moodTag: Int = 1
		moodButtons.forEach { mood in
			mood.backgroundColor = .clear
		}
		
		moodTag = sender.tag
		sender.backgroundColor = UIColor.neonPurple
		sender.layer.cornerRadius = sender.layer.frame.height / 2
		sender.clipsToBounds = true
	}
	// MARK: - Feature : Recording
	private lazy var backgroundView3: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(white: 1, alpha: 0.5)
		view.layer.cornerRadius = 10
		view.clipsToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var backgroundView4: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(white: 1, alpha: 0.5)
		view.layer.cornerRadius = 10
		view.clipsToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var recordingStack: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [recordLabel, recordingButton])

		stackView.axis = .horizontal
		stackView.alignment = .leading
		stackView.distribution = .equalSpacing
		return stackView
	}()
	
	private lazy var recordLabel: UILabel = {
		let label = UILabel()
		label.attributedText = .attributeFont(font: .GMSansMedium, size: 16, text: "당신의 소리를 기록해보세요.", lineHeight: 16)
		return label
	}()
	
	private lazy var recordingButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "waveform.circle.fill"), for: .normal)
		button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
//		button.frame = CGRect(x: 300, y: 64, width: 32, height: 32)
		button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
		button.tintColor = .black
		button.addTarget(self, action: #selector(touchUpbottomSheet), for: .touchUpInside)
		return button
	}()
	
	@objc func touchUpbottomSheet(_ sender: UIButton) {
		let viewController = RecordingViewController()
		viewController.isModalInPresentation = true
		if let sheet = viewController.presentationController as? UISheetPresentationController {
			sheet.preferredCornerRadius = 20
			viewController.sheetPresentationController?.detents = [
				.custom(resolver: { context in
				0.5 * context.maximumDetentValue
			})]
			
			viewController.sheetPresentationController?.largestUndimmedDetentIdentifier = .medium
			viewController.sheetPresentationController?.prefersGrabberVisible = true
		}

		present(viewController, animated: true)
		
	}
	//MARK: - user's Location
	private lazy var locationStack: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [locationLabel, coreLocationButton])
		stackView.axis = .horizontal
		stackView.alignment = .leading
		stackView.distribution = .equalSpacing
		return stackView
	}()
	
	private lazy var locationLabel: UILabel = {
		let label = UILabel()
		label.attributedText = .attributeFont(font: .GMSansMedium, size: 16, text: "어디서 기록했나요?", lineHeight: 16)
		return label
	}()
	
	private lazy var coreLocationButton: UIButton = {
		let button = UIButton()
		//location.fill
		button.setImage(UIImage(systemName: "location.fill"), for: .normal)
		button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
		button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
		button.tintColor = .black
		button.addTarget(self, action: #selector(toggleView), for: .touchUpInside)
		return button
	}()
	
	let addressLabel: UILabel = {
			let label = UILabel()
			label.numberOfLines = 0
			label.translatesAutoresizingMaskIntoConstraints = false
			return label
	}()
	
	@objc func getUserLocation() {
//		locationManager.startUpdatingLocation()
		locationManager.requestLocation()
		
	}
	
	// MARK: - setupUI
	private func setupUI() {
		
		self.view.addSubview(scrollView)
		scrollView.snp.makeConstraints {
			$0.top.equalToSuperview().inset(10)
			$0.centerX.equalToSuperview()
			$0.bottom.equalToSuperview()
			$0.width.equalToSuperview()
		}
		scrollView.addSubview(contentView)
		contentView.snp.makeConstraints {
			$0.edges.equalToSuperview()
//			$0.top.equalTo(scrollView.snp.top).inset(200)
//			$0.top.equalTo(scrollView.snp.top).inset(5)
			$0.width.equalToSuperview()
			$0.height.equalTo(800)
		}
		
		contentView.addSubview(buttonStack)
		buttonStack.snp.makeConstraints {
			$0.top.equalTo(contentView.snp.top).inset(48)
			$0.leading.equalToSuperview().inset(28)
			$0.trailing.equalToSuperview().inset(28)
			$0.height.equalTo(40)
		}
		
		cancelButton.snp.makeConstraints {
//			$0.leading.equalToSuperview()
			$0.width.equalTo(72)
			$0.height.equalTo(40)
		}
		
		saveButton.snp.makeConstraints {
//			$0.trailing.equalToSuperview()
			$0.width.equalTo(72)
			$0.height.equalTo(40)
		}
		
		contentView.addSubview(backgroundView)
		backgroundView.addSubview(date)
		
		backgroundView.snp.makeConstraints {
			$0.top.equalTo(buttonStack.snp.bottom).offset(24)
			$0.leading.equalToSuperview().inset(28)
			$0.trailing.equalToSuperview().inset(28)
			$0.height.equalTo(48)
		}
		
		date.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.centerY.equalToSuperview()
			$0.height.equalTo(100)
		}
		
		contentView.addSubview(titleTextField)
		titleTextField.snp.makeConstraints{
			$0.top.equalTo(backgroundView.snp.bottom).offset(24)
			$0.leading.equalToSuperview().inset(28)
			$0.trailing.equalToSuperview().inset(28)
			$0.height.equalTo(48)
		}
		//MARK: - moodButton Autolayout
		contentView.addSubview(backgroundView2)
		backgroundView2.snp.makeConstraints {
			$0.top.equalTo(titleTextField.snp.bottom).offset(24)
			$0.leading.equalToSuperview().inset(28)
			$0.trailing.equalToSuperview().inset(28)
			$0.height.equalTo(48)
		}
		backgroundView2.addSubview(moodStackView)
		moodStackView.snp.makeConstraints {
			//			$0.top.equalTo(backgroundView2).inset(10)
//			$0.leading.equalToSuperview().inset(28)
//			$0.trailing.equalToSuperview().inset(28)
			$0.left.right.equalTo(backgroundView2).inset(24)
			$0.edges.equalToSuperview()
//			$0.centerY.equalToSuperview()
		}
		
		for button in moodButtons {
			moodStackView.addArrangedSubview(button)
		}
		
		for (idx, button) in moodButtons.enumerated() {
			button.snp.makeConstraints {
				$0.height.equalTo(32)
//				$0.width.equalTo(16)
//				$0.leading.equalTo(moodStackView.snp.leading).inset(24)
			}
		}
		
		//MARK: - Recording StackView
//		self.view.addSubview(recordingView)
//		recordingView.snp.makeConstraints{
//			$0.top.equalTo(backgroundView2.snp.bottom).offset(24)
//		}
		contentView.addSubview(backgroundView3)
		backgroundView3.addSubview(recordingStack)
		backgroundView3.snp.makeConstraints {
			$0.top.equalTo(backgroundView2.snp.bottom).offset(24)
			$0.leading.equalToSuperview().inset(28)
			$0.trailing.equalToSuperview().inset(28)
			$0.height.equalTo(48)
		}
		
		recordingStack.snp.makeConstraints{
			$0.centerY.equalToSuperview()
			$0.leading.equalToSuperview().inset(10)
			$0.trailing.equalToSuperview().inset(28)
//			$0.top.equalTo(backgroundView3.snp.top)
		}
		recordLabel.snp.makeConstraints {
			$0.leading.equalTo(recordingStack.snp.leading).inset(10)
			$0.centerY.equalTo(recordingStack.snp.centerY)
			$0.width.equalTo(198)
			$0.height.equalTo(40)
		}
		
		recordingButton.snp.makeConstraints {
//			$0.trailing.equalToSuperview()
			$0.centerY.equalTo(recordingStack.snp.centerY)
			$0.width.equalTo(32)
			$0.height.equalTo(32)
		}
		// MARK: - UITextView
		soundLogTextView.placeholderText = "소리에 대해 작성해봐요."
		contentView.addSubview(soundLogTextView)
		soundLogTextView.translatesAutoresizingMaskIntoConstraints = false
		soundLogTextView.snp.makeConstraints {
			$0.top.equalTo(recordingStack.snp.bottom).offset(24)
			$0.leading.equalToSuperview().inset(28)
			$0.trailing.equalToSuperview().inset(28)
			$0.height.equalTo(200)
		}
		
		// MARK: - USER LOCATION
		contentView.addSubview(backgroundView4)
		backgroundView4.addSubview(locationStack)
		
		backgroundView4.snp.makeConstraints {
			$0.top.equalTo(soundLogTextView.snp.bottom).offset(24)
			$0.leading.equalToSuperview().inset(28)
			$0.trailing.equalToSuperview().inset(28)
			$0.height.equalTo(48)
		}
		
		locationStack.snp.makeConstraints{
			$0.centerY.equalToSuperview()
			$0.leading.equalToSuperview().inset(10)
			$0.trailing.equalToSuperview().inset(28)
//			$0.top.equalTo(backgroundView3.snp.top)
		}
		
		locationLabel.snp.makeConstraints {
			$0.leading.equalTo(locationStack.snp.leading).inset(10)
			$0.centerY.equalTo(locationStack.snp.centerY)
			$0.width.equalTo(198)
			$0.height.equalTo(40)
		}
		
		coreLocationButton.snp.makeConstraints {
//			$0.trailing.equalToSuperview()
			$0.centerY.equalTo(locationStack.snp.centerY)
			$0.width.equalTo(32)
			$0.height.equalTo(32)
		}
		
		backgroundView4.addSubview(addressLabel)
		addressLabel.snp.makeConstraints {
//			$0.leading.equalTo(backgroundView4.snp.leading).inset(10)
			$0.trailing.equalTo(backgroundView4.snp.trailing).inset(-20)
			$0.centerY.equalTo(backgroundView4.snp.centerY)
//			$0.width.equalTo(240)
			$0.height.equalTo(40)
		}
	}// : setupUI
}

extension SoundLogViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.x > 0 {
			scrollView.contentOffset.x = 0
		}
	}
}
extension SoundLogViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}


extension CLPlacemark {
	var formattedAddress: String? {
		if let name = name, let locality = locality, let administrativeArea = administrativeArea {
			return "\(name), \(locality), \(administrativeArea)"
		}
		return nil
	}
}
