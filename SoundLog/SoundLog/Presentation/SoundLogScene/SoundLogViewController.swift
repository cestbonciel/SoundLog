//
//  RecordingSoundLogViewController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/24.
//
import UIKit
import MapKit

import SnapKit

class SoundLogViewController: UIViewController, CLLocationManagerDelegate{
    
    var viewModel = SoundLogViewModel()
    
    private let soundLogView = SoundLogView()
    private let customPlayerView = CustomPlayerView()
    private let categoryIconView = CategoryIconView(type: .recording)
    //MARK: - CLLocation
    var locationManager2: CLLocationManager?
    weak var mapDelegate: MapViewControllerDelegate?

    //MARK: - Life Cycle
    override func loadView() {
        view = soundLogView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.pastelSkyblue
        setTargetActions()
        navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.isHidden = true
       //scrollView.delegate = self
        soundLogView.soundLogTitle.delegate = self
        
        
        bind()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Objc Action 관리 ⭐️
    func setTargetActions() {
        soundLogView.cancelButton.addTarget(self, action: #selector(actCancelButton), for: .touchUpInside)
        soundLogView.saveButton.addTarget(self, action: #selector(saveSoundLogs), for: .touchUpInside)
        soundLogView.soundLogDate.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        soundLogView.soundLogTitle.addTarget(self, action: #selector(titleTextFieldDidChange), for: .editingChanged)
        soundLogView.moodButtons.forEach { button in
            button.addTarget(self, action: #selector(selectMood), for: .touchUpInside)
        }
        soundLogView.recordingButton.addTarget(self, action: #selector(touchUpbottomSheet), for: .touchUpInside)
        soundLogView.coreLocationButton.addTarget(self, action: #selector(pinnedCurrentLocation), for: .touchUpInside)
        soundLogView.selectedRecBtn.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        soundLogView.selectedASMRBtn.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        viewModel.createdAt.value = sender.date
    }
    
    @objc func titleTextFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else { return }
    
        if sender.text?.first == " " {
            sender.text = String(sender.text!.dropFirst())
            return
        }
        
        viewModel.soundTitle.value = sender.text ?? ""
        
        if viewModel.titleLimitExceeded {
            sender.text = String(sender.text!.prefix(10))
            showLimitAlert()
        }
        
        updateSaveButtonState()
    }
    
    private func showLimitAlert() {
        let alertController = UIAlertController(title: "경고", message: "제목은 1자 이상 10자 이하여야 합니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    //var selectedMood: MoodEmoji?
    
    @objc private func selectMood(_ sender: UIButton) {
        soundLogView.moodButtons.forEach { button in
            button.backgroundColor = .clear
            button.layer.cornerRadius = 0
            button.clipsToBounds = true
        }
        sender.backgroundColor = UIColor.neonPurple
        sender.layer.cornerRadius = sender.layer.frame.height / 2
        sender.clipsToBounds = true
        
       
        viewModel.updateMood(with: sender.tag)
        
        updateSaveButtonState()
    }
    
    private func diselectMoodAlert() {
        let alertController = UIAlertController(title: "안내", message: "감정을 선택해주세요.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    @objc func actCancelButton(_ sender: UIButton) {
        
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
    
    @objc func saveSoundLogs() {
        viewModel.create()
        dismiss(animated: true)
        
    }
  
    // MARK: - Presenting view for REC
    @objc func touchUpbottomSheet(_ sender: UIButton) {
        let viewController = RecordingViewController()
        viewController.viewModel = viewModel
        viewController.isModalInPresentation = true
        if let sheet = viewController.presentationController as? UISheetPresentationController {
            sheet.preferredCornerRadius = 20
            viewController.sheetPresentationController?.detents = [
                .custom(resolver: { context in
                0.3 * context.maximumDetentValue
            })]
            
            viewController.sheetPresentationController?.largestUndimmedDetentIdentifier = .medium
            viewController.sheetPresentationController?.prefersGrabberVisible = true
        }

        present(viewController, animated: true)
    }
       
    private var selectedButton: UIButton?
  
    @objc func categoryButtonTapped(_ sender: UIButton) {
        if sender == selectedButton {
            sender.backgroundColor = UIColor.black
            sender.setTitleColor(.white, for: .normal)
            selectedButton = nil
        } else {
            selectedButton?.backgroundColor = .black
            selectedButton?.setTitleColor(.white, for: .normal)
            sender.backgroundColor = UIColor.neonYellow
            sender.setTitleColor(.black, for: .normal)
            selectedButton = sender
        }
        
        viewModel.soundCategory.value = sender == soundLogView.selectedRecBtn ? "Recording" : "ASMR"
        updateSaveButtonState()
    }
    
    // MARK: - action method
    @objc func pinnedCurrentLocation(_ sender: UIButton) {
        let mapVC = MapViewController()
        mapVC.viewModel = viewModel
        mapVC.currentLocationAddress = soundLogView.addressLabel.text
        mapVC.mapDelegate = self
        mapVC.isModalInPresentation = true
        mapVC.modalPresentationStyle = .popover
        self.present(mapVC, animated: true, completion: nil)
        checkLocationPermission()
        updateSaveButtonState()
    }
    
    private func checkLocationPermission() {
        locationManager2 = CLLocationManager()
        locationManager2?.delegate = self
        locationManager2?.requestWhenInUseAuthorization()
        locationManager2?.desiredAccuracy = kCLLocationAccuracyBest
        DispatchQueue.global(qos: .userInitiated).async {
            if CLLocationManager.locationServicesEnabled() {
                switch self.locationManager2?.authorizationStatus {
                case .authorizedAlways, .authorizedWhenInUse:
                    // 위치 권한이 승인되어 있는 경우
                    self.locationManager2?.startUpdatingLocation()
                case .notDetermined:
                    // 위치 권한을 요청받지 않은 경우
                    DispatchQueue.main.async {
                        self.locationManager2?.requestAlwaysAuthorization()
                    }
                case .denied, .restricted:
                    // 위치 권한이 거부되거나 제한된 경우
                    DispatchQueue.main.async {
                        self.showLocationServicesDisabledAlert2()
                    }
                    break
                default:
                    break
                }
            } else {
                self.showLocationServicesDisabledAlert2()
            }
        }
    }//: CheckLocationPermission
    
    func showLocationServicesDisabledAlert2() {
        
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
    
    func bind() {
        //1. 날짜
        viewModel.createdAt.bind { date in
            self.soundLogView.soundLogDate.date = date
        }
        //2. 제목
        viewModel.soundTitle.bind { text in
            self.soundLogView.soundLogTitle.text = text
        }
        //3. 감정
        viewModel.soundMood.bind { mood in
            self.soundLogView.moodButtons.forEach { button in
                if button.title(for: .normal) == mood {
                    button.backgroundColor = UIColor.neonPurple
                    button.layer.cornerRadius = button.frame.height / 2
                    button.clipsToBounds = true
                } else {
                    button.backgroundColor = .clear
                }
            }
        }
        
        //4.녹음
        viewModel.recordedFileUrl.bind { [weak self] recordFile in
            guard let url = recordFile?.recordedFileUrl, let urlObject = URL(string: url) else { return }

            self?.customPlayerView.queueSound(url: urlObject)
            self?.updateSaveButtonState()
        }

        //5.위치
        viewModel.soundLocation.bind { location in
            self.soundLogView.addressLabel.text = location
        }
        //6.카테고리선택
        viewModel.soundCategory.bind { [weak self] category in
            guard let strongSelf = self else { return }
            let categoryType: CategoryIconType
            switch category {
            case "Recording":
                categoryType = .recording
            case "ASMR":
                categoryType = .asmr
            default:
                categoryType = .recording
            }
            strongSelf.categoryIconView.updateType(type: categoryType)
        }
    }
    
    // MARK: - 제목, 내용 글자 수 제한 --
    func updateSaveButtonState() {
        let titleLength = !viewModel.titleLimitExceeded
        let mood = viewModel.moodIsSelected
        let sound = viewModel.soundIsValid
        let location = viewModel.locationIsValid
        let category = viewModel.categoryIsValid
        //soundLogView.saveButton.isEnabled = titleLength && sound && location && category
        //let formIsValid = titleLength && mood && sound && location && category
        soundLogView.updateSaveButton(isEnabled: true)
    }
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
        print("textFieldShouldReturn called")
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Map
extension SoundLogViewController: MapViewControllerDelegate {
    func didSelectLocationWithAddress(_ address: String?) {
         if let address = address {
             viewModel.soundLocation.value = address
             soundLogView.addressLabel.text = address
         }
    }
    
    func dismissMapViewController() {
         dismiss(animated: true, completion: nil)
    }
}


