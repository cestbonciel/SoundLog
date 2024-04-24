//
//  SoundLogDetailViewController.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/15.
//

import UIKit
import MapKit

import SnapKit

class SoundLogDetailViewController: UIViewController, CLLocationManagerDelegate {
    var editSoundLogData: StorageSoundLog?
    var editViewModel: SoundLogViewModel!
    private let soundLogDetailView = SoundLogDetailView()
    var customPlayerView: CustomPlayerView?
    private let editCategoryIcon = CategoryIconView(type: .recording)
    
    //MARK: - CLLocation
    var locationManager2: CLLocationManager?
    weak var mapDelegate: MapViewControllerDelegate?

    //MARK: - Life Cycle
    override func loadView() {
        view = soundLogDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setTargetActions()
        navigationController?.hidesBarsOnSwipe = true
        soundLogDetailView.soundLogTitle.delegate = self
        loadSavedData()
        bindViewModelToView()
    }
    
    func loadSavedData() {
        if let editSoundLog = editSoundLogData {
            editViewModel.createdAt.value = editSoundLog.createdAt
            editViewModel.soundTitle.value = editSoundLog.soundTitle
            editViewModel.soundMood.value = editSoundLog.soundMood
            editViewModel.recordedFileUrl.value = editSoundLog.soundRecordFile
            editViewModel.soundLocation.value = editSoundLog.soundLocation
            editViewModel.soundCategory.value = editSoundLog.soundCategory
        }
    }
    
    private func bindViewModelToView() {
        // 1. 날짜
        editViewModel.createdAt.bind { [weak self] date in
            self?.soundLogDetailView.soundLogDate.date = date
            self?.updateEditState()
        }
        // 2. 제목
        editViewModel.soundTitle.bind { [weak self] title in
            self?.soundLogDetailView.soundLogTitle.text = title
            self?.updateEditState()
        }
        // 3. 감정
        editViewModel.soundMood.bind { [weak self] mood in
            guard let moodIndex = MoodEmoji.emojis.firstIndex(of: mood) else { return }
            self?.soundLogDetailView.moodButtons.forEach { button in
                button.backgroundColor = .clear
                if button.tag == moodIndex {
                    button.isSelected = true
                    button.backgroundColor = .neonPurple
                }
            }
            self?.updateEditState()
        }
        
        // 4. 녹음
        editViewModel.recordedFileUrl.bind { [weak self] recordedFile in
            if let urlString = recordedFile?.recordedFileUrl,
               let url = URL(string: urlString) {
                self?.customPlayerView?.queueSound(url: url)
            }
            //self?.updateEditState()
        }
        // 5. 위치
        editViewModel.soundLocation.bind { [weak self] location in
            DispatchQueue.main.async {
                self?.soundLogDetailView.addressLabel.text = location
            }
            
        }
        // 6. 카테고리
        editViewModel.soundCategory.bind { [weak self] category in
            DispatchQueue.main.async {
                self?.updateCategorySelection(category: category)
            }
           
            self?.updateEditState()
        }
        
        // ViewModel의 데이터가 변경될 때 마다 호출
        editViewModel.hasChangedDatas.bind { [weak self] changed in
            DispatchQueue.main.async {
                self?.soundLogDetailView.updateEditButton(isEnabled: changed)
            }
        }
        
        // 각 바인딩의 끝에 checkForChanges()를 호출하여 변경사항을 확인합니다.
        editViewModel.soundTitle.bind { [weak self] _ in self?.editViewModel.checkForChanges() }
        
    }
    
    private func updateCategorySelection(category: String) {
        let isASMR = category == "ASMR"
        soundLogDetailView.selectedASMRBtn.isSelected = isASMR
        soundLogDetailView.selectedRecBtn.isSelected = !isASMR

        soundLogDetailView.selectedASMRBtn.backgroundColor = isASMR ? .neonYellow : .black
        soundLogDetailView.selectedRecBtn.backgroundColor = isASMR ? .black : .neonYellow
        
        soundLogDetailView.selectedASMRBtn.setTitleColor(isASMR ? .black : .white, for: .normal)
        soundLogDetailView.selectedRecBtn.setTitleColor(isASMR ? .white : .black, for: .normal)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Objc Action 관리 ⭐️
    func setTargetActions() {
        soundLogDetailView.cancelButton.addTarget(self, action: #selector(actCancelButton), for: .touchUpInside)
        soundLogDetailView.deleteButton.addTarget(self, action: #selector(deleteSoundLogs), for: .touchUpInside)
        soundLogDetailView.editButton.addTarget(self, action: #selector(editSave), for: .touchUpInside)
        
        soundLogDetailView.soundLogDate.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        soundLogDetailView.soundLogTitle.addTarget(self, action: #selector(titleTextFieldDidChange), for: .editingChanged)
        soundLogDetailView.moodButtons.forEach { button in
            button.addTarget(self, action: #selector(selectMood), for: .touchUpInside)
        }
        soundLogDetailView.recordingButton.addTarget(self, action: #selector(alertRecordingButtonTapped), for: .touchUpInside)
        soundLogDetailView.coreLocationButton.addTarget(self, action: #selector(alertLocationButtonTapped), for: .touchUpInside)
        soundLogDetailView.selectedRecBtn.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        soundLogDetailView.selectedASMRBtn.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func editSave() {
        if let editLog = editSoundLogData {
            editViewModel.edit(editLog)
            dismiss(animated: true)
        }
        updateEditState()
    }
    
    @objc func deleteSoundLogs() {
        guard let soundLog = editSoundLogData else { return }
        let alert = UIAlertController(title: "\(soundLog.soundTitle)", message: "소리의 기록을 삭제할까요?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] action in
            StorageSoundLog.deleteSoundLog(soundLog)
            self?.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        editViewModel.createdAt.value = sender.date
    }
    
    @objc func titleTextFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text,
              !text.isEmpty else { return }
    
        if sender.text?.count == 1 {
            if sender.text?.first == " " {
                sender.text = ""
                return
            }
        }
        editViewModel.soundTitle.value = sender.text ?? ""
        
        updateEditState()
    }
    
    private func showLimitAlert() {
        let alertController = UIAlertController(title: "경고", message: "제목은 1자 이상 24자 이하여야 합니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    @objc private func selectMood(_ sender: UIButton) {
        var moodTag: Int = 1
        soundLogDetailView.moodButtons.forEach { mood in
            mood.backgroundColor = .clear
        }
        
        moodTag = sender.tag
        sender.backgroundColor = UIColor.neonPurple
        sender.layer.cornerRadius = sender.layer.frame.height / 2
        sender.clipsToBounds = true
        
        editViewModel.updateMood(with: sender.tag)
        
        updateEditState()
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
   
    // MARK: - Presenting view for REC
    @objc func alertRecordingButtonTapped() {
        // 녹음 수정 불가 경고창 표시
        let alert = UIAlertController(title: "알림", message: "녹음 파일은 수정할 수 없습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

    @objc func alertLocationButtonTapped() {
        // 위치 수정 불가 경고창 표시
        let alert = UIAlertController(title: "알림", message: "위치 정보는 수정할 수 없습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
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
        editViewModel.soundCategory.value = sender == soundLogDetailView.selectedRecBtn ? "Recording" : "ASMR"
        updateEditState()
    }
    
    

    // MARK: - 제목, 내용 글자 수 제한 --
    func updateEditState() {
        /*
        let titleLength = editViewModel.titleLimitExceeded
        let mood = editViewModel.moodIsSelected
        //let sound = editViewModel.soundIsValid
        //let location = editViewModel.locationIsValid
        let category = editViewModel.categoryIsValid
        let formIsValid = titleLength && mood && category
        */
        soundLogDetailView.updateEditButton(isEnabled:editViewModel.isFormValid)
    }
}

extension SoundLogDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
extension SoundLogDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Map
extension SoundLogDetailViewController: MapViewControllerDelegate {
    func didSelectLocationWithAddress(_ address: String?) {
         if let address = address {
             editViewModel.soundLocation.value = address
             soundLogDetailView.addressLabel.text = address
         }
    }
    
    func dismissMapViewController() {
         dismiss(animated: true, completion: nil)
    }
}

