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
    
    //private let soundLogView = SoundLogView()
    private let soundLogTextView = LogTextView()
    private let customPlayerView = CustomPlayerView()
    
    //MARK: - CLLocation
    var locationManager2: CLLocationManager?
    weak var mapDelegate: MapViewControllerDelegate?

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.pastelSkyblue
        setupUI()
         
        navigationController?.hidesBarsOnSwipe = true
        scrollView.delegate = self
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    //MARK: - Entire View Scroll
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
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
        button.titleLabel?.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        button.setTitle("취소", for: .normal)
        button.addTarget(self, action: #selector(actCancelButton), for: .touchUpInside)
        return button
    }()
    
     
    // MARK: - Save 녹음 일기 ⭐️
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 72, height: 40)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.neonYellow
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        
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
    
    // MARK: - Date
    private lazy var soundLogDate: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .automatic
        } else {
            datePicker.preferredDatePickerStyle = .wheels
        }
        return datePicker
    }()
    
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
    // MARK: - Diary Forms
    private lazy var soundLogTitle: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 48))
        
        
        let leftInsetView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 48))
        textField.leftView = leftInsetView
        textField.leftViewMode = .always
        textField.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        textField.attributedPlaceholder = NSAttributedString(string: "1자 이상 10자 미만", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
        
        textField.layer.cornerRadius = 10
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        
        textField.returnKeyType = .done
        textField.delegate = self
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.addTarget(self, action: #selector(titleTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    /*
     // SoundLogViewController

     @objc func titleTextFieldDidChange(_ sender: UITextField) {
         guard let text = sender.text, !text.isEmpty else { return }
         
         // 공백으로 시작하는 입력 방지
         if text.count == 1 && text.first == " " {
             sender.text = ""
             return
         }
         
         viewModel.soundTitle.value = text
         
         // 문자 수 제한 초과 시
         if viewModel.titleLimitExceeded {
             sender.text = String(sender.text!.prefix(7)) // 7자로 제한
             showLimitAlert() // 경고 표시 함수 호출
         }
         
         updateForm()
     }

     // 문자 수 제한 초과 시 사용자에게 경고를 표시하는 메서드
     private func showLimitAlert() {
         let alertController = UIAlertController(title: "경고", message: "제목은 1자 이상 7자 미만이어야 합니다.", preferredStyle: .alert)
         let action = UIAlertAction(title: "확인", style: .default)
         alertController.addAction(action)
         present(alertController, animated: true)
     }
     */
    @objc func titleTextFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else { return }
    
        if sender.text?.count == 1 && text.first == " " {
            if sender.text?.first == " " {
                sender.text = ""
                return
            }
        }
        viewModel.soundTitle.value = text
        
        if viewModel.titleLimitExceeded {
            sender.text = String(sender.text!.prefix(10))
            showLimitAlert()
        }
        
        updateForm()
    }
    
    private func showLimitAlert() {
        let alertController = UIAlertController(title: "경고", message: "제목은 1자 이상 10자 미만이어야 합니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
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
            button.titleLabel?.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
            
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
        
        if let moodEmoji = MoodEmoji(rawValue: sender.tag) {
            let moodString = moodEmoji.emojiString
            viewModel.soundMood.value = moodString
        }
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
    
    private lazy var backgroundView5: UIView = {
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
        label.text = "당신의 소리를 기록해보세요."
        label.numberOfLines = 0
        label.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var recordingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "waveform.circle.fill"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(touchUpbottomSheet), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Presenting view for REC
    @objc func touchUpbottomSheet(_ sender: UIButton) {
        let viewController = RecordingViewController()
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
    
    //MARK: - LOCATION STACK VIEW
    private lazy var locationStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationLabel, coreLocationButton])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        label.text = "어디서 기록했나요?"
        return label
    }()
    
    private lazy var coreLocationButton: UIButton = {
        let button = UIButton()
        //location.fill
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
        button.tintColor = .black
        button.tintColor = .black
        button.addTarget(self, action: #selector(pinnedCurrentLocation), for: .touchUpInside)
        return button
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        label.text = "카테고리 선택"
        return label
    }()
    
    private lazy var categoryBtnStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [selectedRecBtn, selectedASMRBtn])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var selectedButton: UIButton?
    
    private lazy var selectedRecBtn: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 56, height: 32)
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.setTitle("녹음", for: .normal)
        button.titleLabel?.font = .gmsans(ofSize: 12, weight: .GMSansMedium)
        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var selectedASMRBtn: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 56, height: 32)
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.setTitle("ASMR", for: .normal)
        button.titleLabel?.font = .gmsans(ofSize: 12, weight: .GMSansMedium)
        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
    }
    
    // MARK: - action method
    @objc func pinnedCurrentLocation() {
        let mapVC = MapViewController()
        mapVC.currentLocationAddress = addressLabel.text
        mapVC.mapDelegate = self
        mapVC.isModalInPresentation = true
        mapVC.modalPresentationStyle = .popover
        self.present(mapVC, animated: true, completion: nil)
        checkLocationPermission()
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
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .gmsans(ofSize: 12, weight: .GMSansMedium)
        return label
    }()
    
    // MARK: - setupUI
    private func setupUI() {
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
            $0.width.equalTo(72)
            $0.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints {
            $0.width.equalTo(72)
            $0.height.equalTo(40)
        }
        
        contentView.addSubview(backgroundView)
        backgroundView.addSubview(soundLogDate)
        
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(buttonStack.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(48)
        }
        
        soundLogDate.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        contentView.addSubview(soundLogTitle)
        soundLogTitle.snp.makeConstraints{
            $0.top.equalTo(backgroundView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(48)
        }
        //MARK: - moodButton Autolayout
        contentView.addSubview(backgroundView2)
        backgroundView2.snp.makeConstraints {
            $0.top.equalTo(soundLogTitle.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(48)
        }
        backgroundView2.addSubview(moodStackView)
        moodStackView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(4)
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        for button in moodButtons {
            moodStackView.addArrangedSubview(button)
        }
        
        for (_, button) in moodButtons.enumerated() {
            button.snp.makeConstraints {
                $0.height.equalTo(32)
            }
        }
        
        //MARK: - Recording StackView

        contentView.addSubview(backgroundView3)
        backgroundView3.addSubview(recordingStack)
        backgroundView3.snp.makeConstraints {
            $0.top.equalTo(backgroundView2.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(48)
        }
        
        recordingStack.snp.makeConstraints{
            $0.centerY.equalTo(backgroundView3.snp.centerY)
            $0.leading.equalTo(backgroundView3.snp.leading).inset(16)
            $0.trailing.equalTo(backgroundView3.snp.trailing).inset(16)
        }
        recordLabel.snp.makeConstraints {
            $0.centerY.equalTo(recordingStack.snp.centerY)
        }
        
        recordingButton.snp.makeConstraints {
            $0.centerY.equalTo(recordingStack.snp.centerY)
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }
        
        
        // MARK: - UITextView
        soundLogTextView.placeholderText = "소리에 대해 작성해봐요."
        contentView.addSubview(soundLogTextView)

        soundLogTextView.snp.makeConstraints {
            $0.top.equalTo(recordingStack.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(28)
            $0.height.equalTo(180)
        }

        // MARK: - USER LOCATION
        contentView.addSubview(backgroundView4)
        backgroundView4.addSubview(locationStack)
        contentView.addSubview(addressLabel)
        
        backgroundView4.snp.makeConstraints {
            $0.top.equalTo(soundLogTextView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(28)
            $0.height.equalTo(48)
        }
        
        locationStack.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(16)
        }

        locationLabel.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalTo(locationStack.snp.centerY)
        }
        
        coreLocationButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(locationStack.snp.top).offset(56)
            $0.right.equalTo(coreLocationButton.snp.right)
        }
       
        
        contentView.addSubview(backgroundView5)
        backgroundView5.addSubview(categoryLabel)
        backgroundView5.addSubview(categoryBtnStack)

        
        backgroundView5.snp.makeConstraints {
            $0.top.equalTo(backgroundView4.snp.bottom).offset(56)
            $0.left.right.equalToSuperview().inset(28)
            $0.height.equalTo(48)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(backgroundView5.snp.leading).inset(20)
            $0.centerY.equalTo(backgroundView5.snp.centerY)
            $0.width.equalTo(198)
            $0.height.equalTo(40)
        }
        
        categoryBtnStack.snp.makeConstraints {
            $0.trailing.equalTo(backgroundView5.snp.trailing).inset(16)
            $0.centerY.equalTo(backgroundView5.snp.centerY)
            $0.width.equalTo(134)
        }
        
        selectedRecBtn.snp.makeConstraints {
            $0.width.equalTo(56)
            $0.height.equalTo(32)
        }
        
        selectedASMRBtn.snp.makeConstraints {
            $0.width.equalTo(56)
            $0.height.equalTo(32)
        }
        
    }// : setupUI
    
    // MARK: - 제목, 내용 글자 수 제한 --
    func updateForm() {
        let titleLength = viewModel.titlelimit
        let mood = viewModel.moodIsValid
        let sound = viewModel.soundIsValid
        let location = viewModel.locationIsValid
        let category = viewModel.categoryIsValid
        saveButton.isEnabled = titleLength && mood && sound && location && category
    }
}

extension SoundLogViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
// MARK: - TextField
extension SoundLogViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count < 1 && updatedText.count > 7 {
            presentAlertForInputLimit()
            return false
        }
        
        return true
    }
    
    private func presentAlertForInputLimit() {
        let alertController = UIAlertController(title: "경고", message: "제목은 7자를 초과할 수 없습니다.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    */
}

// MARK: - Map
extension SoundLogViewController: MapViewControllerDelegate {
    func didSelectLocationWithAddress(_ address: String?) {
         if let address = address {
              addressLabel.text = address
         }
    }
    
    func dismissMapViewController() {
         dismiss(animated: true, completion: nil)
    }
}

//MARK: - SwiftUI Preview Setting
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct SoundLogViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return UIStoryboard(name: "RecordingSound", bundle: nil).instantiateViewController(withIdentifier: "Record")
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct SoundLogViewController_Preview: PreviewProvider {
    static var previews: some View {
        SoundLogViewControllerRepresentable()
    }
}
#endif
