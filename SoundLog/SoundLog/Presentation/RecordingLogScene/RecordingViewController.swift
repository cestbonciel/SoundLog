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

	var isRecording = false
	var isPlaying = false
	

	var audioFileURL: URL!

	
	let maxVolume: Float = 10.0

	//MARK: - viewDidLoad()
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupUI()
		view.backgroundColor = .pastelSkyblue
		
		setPlayAndRecordSession()
//		setupAudioRecorder()
		// default Record
		updateUIForRecording(false, true, false)
	
	}//: viewDidLoad()
	

	// MARK: - Recording Objects
	lazy var mainLabel: UILabel = {
		let label = UILabel()
		label.text = "음성 녹음"
		label.font = UIFont(name: "GmarketSansMedium", size: 16.0)
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	// MARK: - the State of Playing
	lazy var progressView: UIProgressView = {
		let progressView = UIProgressView(progressViewStyle: .bar)
//		progressView.setProgress(0.0, animated: true)
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
	
	// MARK: - Limit Recording Time
	private let limitTimeStackView: UIStackView = {
		let view = UIStackView()
		view.axis = .horizontal
		view.distribution = .fillProportionally
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var limitLabel: UILabel = {
		let label = UILabel()
		label.text = "기록 제한시간"
		label.font = .prtendard(ofSize: 13, weight: .PRTendardMedium)
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	lazy var segmentControl: UISegmentedControl = {
		let segmentControl = UISegmentedControl(items: ["15초", "30초", "60초"])
		segmentControl.translatesAutoresizingMaskIntoConstraints = false
		return segmentControl
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
//		button.layer.masksToBounds = false
		button.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
		button.layer.cornerRadius = button.frame.width / 2
		button.translatesAutoresizingMaskIntoConstraints = false
		
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
//		button.layer.masksToBounds = false
		button.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
		button.layer.cornerRadius = button.frame.width / 2
		button.translatesAutoresizingMaskIntoConstraints = false

//		button.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
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
		self.dismiss(animated: true, completion: nil)
	}
	
	lazy var uploadButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
		button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
		button.tintColor = .neonPurple
		return button
	}()

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

		// MARK: Limit time -
		view.addSubview(limitTimeStackView)
		limitTimeStackView.addArrangedSubview(limitLabel)
		limitTimeStackView.addArrangedSubview(segmentControl)
		
		NSLayoutConstraint.activate([
			
			limitTimeStackView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 32),
			limitTimeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
			limitTimeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
			
			limitTimeStackView.heightAnchor.constraint(equalToConstant: 40),
			
		])
		
		NSLayoutConstraint.activate([
			limitLabel.leadingAnchor.constraint(equalTo: limitTimeStackView.leadingAnchor),
		
			limitLabel.centerYAnchor.constraint(equalTo: limitTimeStackView.centerYAnchor),
			
			segmentControl.trailingAnchor.constraint(equalTo: limitTimeStackView.trailingAnchor),
			segmentControl.heightAnchor.constraint(equalToConstant: 40),
			segmentControl.centerYAnchor.constraint(equalTo: limitLabel.centerYAnchor)
			
		])
		
		
		// MARK: record Button StackView -
		view.addSubview(recorderButtonStackView)
		recorderButtonStackView.addArrangedSubview(playButton)
		recorderButtonStackView.addArrangedSubview(recordButton)
		recorderButtonStackView.addArrangedSubview(stopButton)

		NSLayoutConstraint.activate([
			recorderButtonStackView.topAnchor.constraint(equalTo: limitTimeStackView.bottomAnchor, constant: 32),
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


