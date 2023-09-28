//
//  RecordingViewController.swift
//  FeatureRecording
//
//  Created by Seohyun Kim on 2023/09/12.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController {
	
	var audioRecorder: AVAudioRecorder?
	var audioPlayer: AVAudioPlayer!
	var progressTimer: Timer?

	var isRecording = false
	var isPlaying = false
	

	var audioFileName: URL! = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("recording.m4a")

	
	let maxVolume: Float = 10.0
	
	let timePlayer: Selector = #selector(updatePlayTime)
	let timeRecord: Selector = #selector(updateRecordTime)
	
	var isRecordMode = false
	
	let timePlayerSelector: Selector = #selector(RecordingViewController.updatePlayTime)
	let timeRecordSelector: Selector = #selector(RecordingViewController.updateRecordTime)
	//MARK: - viewDidLoad()
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupUI()
		view.backgroundColor = .pastelSkyblue
		setUpAudioSession()
		setupAudioRecorder()
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

	lazy var timeStackView: UIStackView = {
		let view = UIStackView()
		view.axis = .horizontal
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	lazy var timerLabel: UILabel = {
		let label = UILabel()
		label.text = "00:00"
		label.font = UIFont.systemFont(ofSize: 12)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	// MARK: - Limit Recording Time
	private let stackView: UIStackView = {
		let view = UIStackView()
		view.axis = .horizontal
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var limitLabel: UILabel = {
		let label = UILabel()
		label.text = "기록 제한시간"
		label.font = UIFont.systemFont(ofSize: 16)
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	lazy var segmentControl: UISegmentedControl = {
		let segmentControl = UISegmentedControl(items: ["15초", "30초", "60초"])
		segmentControl.translatesAutoresizingMaskIntoConstraints = false
		return segmentControl
	}()
	// MARK: - bottom Button Components
	private let buttonStackView: UIStackView = {
		let view = UIStackView()
		view.axis = .horizontal
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
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
	
	lazy var recordButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "record.circle.fill"), for: .normal)
		button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
		button.tintColor = .red
		button.addTarget(self, action: #selector(tapButtonRecord), for: .touchUpInside)
		return button
	}()
	
	lazy var playButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
		button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
		button.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
		return button
	}()

	lazy var stopButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
		button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
		button.tintColor = .systemPink
		button.addTarget(self, action: #selector(stopButtonPressed), for: .touchUpInside)
		return button
	}()

	
	lazy var sliderVolume: UISlider = {
		let slider = UISlider(frame: CGRect(x: 0, y: 320, width: 300, height: 24))
		slider.minimumValue = 0.0
		slider.maximumValue = 100.0
		slider.value = 5.0
		slider.translatesAutoresizingMaskIntoConstraints = false
		slider.addTarget(self, action: #selector(sliderValueChanged), for: .touchUpInside)
		return slider
	}()
	
	
	
	lazy var cancelButton: UIButton = {
		let button = UIButton()
		button.setTitle("취소", for: .normal)
		button.backgroundColor = .systemDimGray
		button.tintColor = .black
		button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
		button.layer.cornerRadius = 20
		button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
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
		self.view.backgroundColor = .systemBackground
		self.view.addSubview(mainLabel)
		self.view.addSubview(progressView)
		
		
		NSLayoutConstraint.activate([
			mainLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			mainLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 30),
			
			progressView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 64),
			progressView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor,constant: 30),
			progressView.heightAnchor.constraint(equalToConstant: 32),
			progressView.widthAnchor.constraint(equalToConstant: 300),

		])
		
		self.view.addSubview(timeStackView)
		timeStackView.addArrangedSubview(timerLabel)
		
		NSLayoutConstraint.activate([
			timeStackView.leadingAnchor.constraint(equalTo: timeStackView.leadingAnchor),
			timeStackView.trailingAnchor.constraint(equalTo: progressView.trailingAnchor),
			timeStackView.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
			timerLabel.trailingAnchor.constraint(equalTo:	progressView.trailingAnchor, constant: -10),
			timerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -64)
		])
		
		view.bringSubviewToFront(timeStackView)
		
		
		self.view.addSubview(sliderVolume)
		// MARK: record Button StackView -
		self.view.addSubview(recorderButtonStackView)
		recorderButtonStackView.addArrangedSubview(playButton)
		recorderButtonStackView.addArrangedSubview(recordButton)
		recorderButtonStackView.addArrangedSubview(stopButton)
		
		NSLayoutConstraint.activate([
			sliderVolume.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			sliderVolume.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 30),
			sliderVolume.widthAnchor.constraint(equalToConstant: 300),
			sliderVolume.heightAnchor.constraint(equalToConstant: 40),
		])

		
		NSLayoutConstraint.activate([
			recorderButtonStackView.topAnchor.constraint(equalTo: sliderVolume.bottomAnchor, constant: 30),
			recorderButtonStackView.widthAnchor.constraint(equalToConstant: 300),
			recorderButtonStackView.heightAnchor.constraint(equalToConstant: 40),
			recorderButtonStackView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 30),
			
			recorderButtonStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
		])
		
		self.view.addSubview(buttonStackView)
		buttonStackView.addArrangedSubview(cancelButton)
		buttonStackView.addArrangedSubview(uploadButton)
		
		// MARK: save and cancel Button StackView -
		NSLayoutConstraint.activate([
			buttonStackView.widthAnchor.constraint(equalToConstant: 328),
			buttonStackView.heightAnchor.constraint(equalToConstant: 40),
			buttonStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300),
			buttonStackView.leftAnchor.constraint(greaterThanOrEqualTo: self.view.leftAnchor, constant: 32),
			buttonStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			
			cancelButton.widthAnchor.constraint(equalToConstant: 64),
			cancelButton.heightAnchor.constraint(equalToConstant: 32),
			cancelButton.trailingAnchor.constraint(equalTo: uploadButton.leadingAnchor, constant: -200),
			uploadButton.widthAnchor.constraint(equalToConstant: 32),
			uploadButton.heightAnchor.constraint(equalToConstant: 32),
			
		])
		
		// MARK: Limit time -
		self.view.addSubview(stackView)
		stackView.addArrangedSubview(limitLabel)
		stackView.addArrangedSubview(segmentControl)
		
		NSLayoutConstraint.activate([
			stackView.widthAnchor.constraint(equalToConstant: 300),
			stackView.heightAnchor.constraint(equalToConstant: 32),
			stackView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 30),
			stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
			stackView.bottomAnchor.constraint(equalTo: sliderVolume.topAnchor, constant: -10)
		])
		
		NSLayoutConstraint.activate([
			limitLabel.widthAnchor.constraint(equalToConstant: 90),
			limitLabel.heightAnchor.constraint(equalToConstant: 16),
			
			segmentControl.widthAnchor.constraint(equalToConstant: 120),
			segmentControl.heightAnchor.constraint(equalToConstant: 40)
			
		])
		
		
	}
}


fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
