//
//  RecordingViewController+AVFoundation.swift
//  FeatureRecording
//
//  Created by Seohyun Kim on 2023/09/16.
//

import UIKit
import AVFoundation

extension RecordingViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate {
	
	// MARK: - RECORDING
	@objc func recordButtonPressed(_ sender: UIButton) {
		
		if audioPlayer != nil && audioPlayer.isPlaying {
			print("stopping")
			audioPlayer.stop()
		}
		
		if audioRecorder == nil {
			print("recording.. recorder nil.")
			progressView.progress = 0.0
			recordButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
			playButton.isEnabled = false
			stopButton.isEnabled = true
			startRecording(true)
//			progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
//			sliderVolume.value = 1.0
//			audioPlayer?.volume = sliderVolume.value
//			timerLabel.text = formatTime(0)
			return
		}
		
		if audioRecorder != nil && audioRecorder.isRecording {
			print("Pausing")
			audioRecorder.pause()
			recordButton.setImage(UIImage(systemName: "mic.circle.fill"), for: .normal)
			
		} else {
			print("Recording")
			recordButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
			playButton.isEnabled = false
			stopButton.isEnabled = true
			startRecording(false)
		}
		
	}
	
	//MARK: - Setup audio session
	func setPlayAndRecordSession() {
		let audioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setCategory(.playAndRecord, mode: .default)
		} catch {
			print("Error setting up audio session: \(error.localizedDescription)")
		}
		
		do {
			try audioSession.setActive(true)
		} catch  let error as NSError {
			print("Error-setActive: \(error)")
		}
	}
	// MARK: Feature - Setup AudioRecorder
	func setupAudioRecorder() {
		let audioSettings: [String: Any] = [
			AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
			AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
			AVEncoderBitRateKey: 320000,
			AVNumberOfChannelsKey: 2,
			AVSampleRateKey: 44100]
		
		let format = DateFormatter()
		format.dateFormat = "yyyy-MM-dd-HH-mm-ss"
		
		let currentFileName = "recording-\(format.string(from: Date()))"
		let uniformTypeIdentifier = UTType.audio
		print(currentFileName)
		
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		self.audioFileURL = documentsDirectory.appendingPathComponent(currentFileName, conformingTo: uniformTypeIdentifier)
		print("writing to soundfile url: \(audioFileURL!)")
		
		if FileManager.default.fileExists(atPath: audioFileURL.absoluteString) {
			print("audio File \(audioFileURL.absoluteString) exists")
		}
		
		do {
			audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: audioSettings)
			audioRecorder?.delegate = self
			audioRecorder?.isMeteringEnabled = true
			audioRecorder?.prepareToRecord()
			
		} catch let error as NSError {
			print("Error-initRecord: \(error)")
		}
	}

	
	// MARK: - functions_ Record
	func startRecording(_ setup: Bool) {
		AVAudioSession.sharedInstance().requestRecordPermission { [unowned self] granted in
			if granted {
				DispatchQueue.main.async {
					self.setPlayAndRecordSession()
					if setup {
						self.setupAudioRecorder()
					}
					self.audioRecorder.record()
					
					self.progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
				}
			} else {
				print("Permission to record not granted.")
			}
		}
		
		if AVAudioSession.sharedInstance().recordPermission == .denied {
			print("permission denied.")
		}
	
	}
	
	func stopRecording() {
	
	}
	
	func playRecordedAudio() {

	}
	
	func updateUIRecording(isRecording: Bool) {
		recordButton.isEnabled = !isRecording
		playButton.isEnabled = !isRecording
		stopButton.isEnabled = isRecording
	}

	func stopPlaying() {
		if isPlaying {
			audioPlayer?.stop()
			isPlaying = false
			
			progressTimer?.invalidate()
		}
	}
	

	

	func updateUIForRecording(_ play: Bool,_ record: Bool,_ stop: Bool) {
		recordButton.isEnabled = record
		playButton.isEnabled = play
		stopButton.isEnabled = stop
	}
	
	// MARK: Feature - Play
	func setPlayButton(_ play: Bool, stop: Bool) {
		playButton.isEnabled = play
		stopButton.isEnabled = stop
	}
	

	//MARK: Progress Bar Timer
	@objc func updateTimer() {
		if isRecording || isPlaying {
			// 녹음 중 또는 재생 중일 때
			let currentTime = isRecording ? audioRecorder.currentTime : audioPlayer.currentTime
			let formattedTime = formatTime(audioRecorder.currentTime ?? 0)

		}
	}
	
	func formatTime(_ time: TimeInterval) -> String {
		let min = Int(time / 60)

		let sec = Int(time.truncatingRemainder(dividingBy: 60))

		let strTime = String(format: "%02d:%02d", min, sec)
		return strTime
	}
	//MARK: - ADD TARGET : PLAY
	@objc func playButtonPressed(_ sender: UIButton) {
		playRecordedAudio()
	}

	@objc func updatePlayTime(){
		timerLabel.text = formatTime(audioPlayer.currentTime)
		progressView.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
	}
	
	@objc func updateRecordTime() {
		timerLabel.text = formatTime(audioRecorder?.currentTime ?? 0)
	}
	
	
	@objc func stopButtonPressed(_ sender: UIButton) {
		stopRecording()

		timerLabel.text = formatTime(audioRecorder?.currentTime ?? 0)

		progressTimer?.invalidate()
		playButton.isEnabled = true

		
	}
	
	@objc func sliderValueChanged(_ sender: UISlider) {
		audioPlayer?.volume = sliderVolume.value
	}
	
	@objc func slChangeVolume(_ sender: UISlider) {
		audioPlayer.volume = sliderVolume.value
	}
	
	// MARK: - AVFoundation Delegate
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		if flag {
			print("Recording finished.")
		} else {
			print("Recording failed.")
		}
	}
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		if flag {
			print("Playing finished.")
		} else {
			print("Playing failed.")
		}
		stopPlaying()
		progressTimer?.invalidate()
		
	}
}
