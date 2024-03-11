//
//  RecordingViewController.swift
//  FeatureRecording
//
//  Created by Seohyun Kim on 2023/09/12.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController {
	
	var audioRecorder: AVAudioRecorder!
	var audioPlayer: AVAudioPlayer!
	var progressTimer: Timer!
    let maxVolume: Float = 10.0
    
    var isRecording: Bool = false
    var isPlaying: Bool = false
    var isPaused: Bool = false
    var statePlaying: Bool = false
    
	var audioFileURL: URL!

	//MARK: - viewDidLoad()
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupUI()
		view.backgroundColor = .pastelSkyblue
        
        stopButton.isEnabled = false
        playButton.isEnabled = false
        setSessionPlayback()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        audioRecorder = nil
        audioPlayer = nil
    }
    
	// MARK: - Recording Objects
	lazy var mainLabel: UILabel = {
		let label = UILabel()
		label.text = "음성 녹음"
        label.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	// MARK: - the State of Playing
	lazy var progressView: UIProgressView = {
		let progressView = UIProgressView(progressViewStyle: .bar)
		progressView.setProgress(0.0, animated: true)
		progressView.trackTintColor = UIColor.systemGray6
		progressView.progressTintColor = UIColor.neonPurple
		progressView.translatesAutoresizingMaskIntoConstraints = false
		return progressView
	}()

	lazy var timerLabel: UILabel = {
		let label = UILabel()
		label.text = "00:00"
		label.font = UIFont.systemFont(ofSize: 12)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
    
	// MARK: - Recorder Button Components
	private let recorderButtonStackView: UIStackView = {
		let view = UIStackView()
		view.axis = .horizontal
		view.alignment = .center
		view.distribution = .equalSpacing
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
    
	//MARK: - RECORD BUTTON
	lazy var recordButton: UIButton = {
		var config = UIButton.Configuration.filled()
		config.image = UIImage(systemName: "mic.fill")
		config.baseBackgroundColor = .systemRed
		config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)

		let button = UIButton(configuration: config)
		button.configuration = config
		button.tintColor = .white
		button.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
		button.layer.cornerRadius = button.frame.width / 2
		button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startRecording), for: .touchUpInside)
		return button
	}()
    
	//MARK: - PLAY BUTTON
	lazy var playButton: UIButton = {
		var config = UIButton.Configuration.filled()
		config.image = UIImage(systemName: "play.fill")
		config.baseBackgroundColor = .neonPurple
		config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)

		let button = UIButton(configuration: config)
		button.configuration = config
		button.tintColor = .white
		button.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
		button.layer.cornerRadius = button.frame.width / 2
		button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startPlaying), for: .touchUpInside)
		return button
	}()
    
	//MARK: - STOP BUTTON
	lazy var stopButton: UIButton = {
		var attString = AttributedString("정지")
		attString.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        
		var config = UIButton.Configuration.borderedTinted()
		config.attributedTitle = attString
		config.baseBackgroundColor = .systemRed
		config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

		let button = UIButton(configuration: config)
		button.configuration = config
		button.tintColor = .systemRed
		button.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
		button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(stopButtonPressed), for: .touchUpInside)
		return button
	}()

	// MARK: - bottom Button Components
	private let buttonStackView: UIStackView = {
		let view = UIStackView()
		view.axis = .horizontal
		view.distribution = .equalSpacing
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	lazy var cancelButton: UIButton = {
		var attString = AttributedString("취소")
		attString.font = .gmsans(ofSize: 16, weight: .GMSansMedium)

		var config = UIButton.Configuration.filled()
		config.attributedTitle = attString
		config.baseBackgroundColor = .systemDimGray
		config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

		let button = UIButton(configuration: config)
		button.configuration = config
		button.tintColor = .systemGray3
		button.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
		button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	@objc func cancelButtonTapped() {
        
         let alertController = UIAlertController(title: "안내", message: "취소하면 녹음한 기록이 사라집니다.", preferredStyle: .alert)
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
	// MARK: - Save Recorded file
	lazy var uploadButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
		button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
		button.tintColor = .neonPurple
        button.addTarget(self, action: #selector(saveRecordedFile), for: .touchUpInside)
		return button
	}()
    
    @objc func saveRecordedFile() {
        guard let recordedAudioURL = audioFileURL else { return }
        
        // RealmManager를 사용하여 녹음된 파일 URL을 저장
        RealmManager.saveRecordedFile(recordedAudioURL) { success in
            DispatchQueue.main.async {
                if success {
                    // 성공적으로 저장된 경우, UI 업데이트를 메인 스레드에서 수행
                    print("Recorded file URL saved successfully.")
                    let alert = UIAlertController(title: "소리의 기록",
                                                  message: "녹음파일을 저장했어요.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default) { [unowned self] _ in
                        print("recorded file saved")
                        self.audioRecorder = nil
                    })
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // 실패한 경우, 사용자에게 실패 메시지 표시
                    print("Failed to save recorded file URL.")
                }
                
            }
            
        }
    }

	// MARK: - Set up User Interfaces
	private func setupUI() {
		view.backgroundColor = .systemBackground
		view.addSubview(mainLabel)
		view.addSubview(progressView)
		
		NSLayoutConstraint.activate([
			mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),

		])

		view.addSubview(timerLabel)
		view.addSubview(progressView)

		NSLayoutConstraint.activate([

			progressView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 32),
			progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
			progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

			progressView.heightAnchor.constraint(equalToConstant: 32),
			timerLabel.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: -16),
			timerLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
		])

		view.bringSubviewToFront(timerLabel)

		
		// MARK: record Button StackView -
		view.addSubview(recorderButtonStackView)
		recorderButtonStackView.addArrangedSubview(playButton)
		recorderButtonStackView.addArrangedSubview(recordButton)
		recorderButtonStackView.addArrangedSubview(stopButton)

		NSLayoutConstraint.activate([
			recorderButtonStackView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 32),
			recorderButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
			recorderButtonStackView.heightAnchor.constraint(equalToConstant: 40),
			recorderButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

			recorderButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
		])

		view.addSubview(buttonStackView)
		buttonStackView.addArrangedSubview(cancelButton)
		buttonStackView.addArrangedSubview(uploadButton)

		// MARK: save and cancel Button StackView -
		NSLayoutConstraint.activate([
			buttonStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
			buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 32),
			buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -32),
			buttonStackView.heightAnchor.constraint(equalToConstant: 40),
			

			cancelButton.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor),
			cancelButton.centerYAnchor.constraint(equalTo: buttonStackView.centerYAnchor),

			uploadButton.trailingAnchor.constraint(equalTo: buttonStackView.trailingAnchor),
			uploadButton.centerYAnchor.constraint(equalTo: buttonStackView.centerYAnchor)

		])
		
	}
}


fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}


#if DEBUG
import SwiftUI
struct RecordPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        RecordingViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

struct RecordingViewController_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            RecordPreview()
        }
    }
}
#endif
