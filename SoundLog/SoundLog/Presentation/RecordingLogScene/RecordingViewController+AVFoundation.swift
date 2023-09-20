//
//  RecordingViewController+AVFoundation.swift
//  FeatureRecording
//
//  Created by Seohyun Kim on 2023/09/16.
//

import UIKit
import AVFoundation

extension RecordingViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate {
	
	
	
	//MARK: - Setup audio session
	func setUpAudioSession() {
		let audioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setCategory(.playback, mode: .default)
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
			AVSampleRateKey: 44100] as [String: Any]
		
		do {
			let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
			let audioFileName = documentsURL.appendingPathComponent("recording.m4a")
			audioRecorder = try AVAudioRecorder(url: audioFileName, settings: audioSettings)
			audioRecorder?.delegate = self
			audioRecorder?.prepareToRecord()
			
		} catch let error as NSError {
			print("Error-initRecord: \(error)")
		}
	}

	
	// MARK: - functions_ Record, Play, Stop
	func startRecording() {
		if !isRecording {
			progressView.progress = 0.0
			audioRecorder?.record()
			isRecording = true
			updateUIForRecording(false, true, false)
			
			progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
			sliderVolume.value = 1.0
			audioPlayer?.volume = sliderVolume.value
			timerLabel.text = convertNSTimeInterval2String(0)
		}

		setPlayButton(true, stop: true)
	
	}
	
	func stopRecording() {
		if isRecording {
			audioRecorder?.stop()
			isRecording = false
			
			updateUIForRecording(false, false, true)

			progressTimer?.invalidate()
		}
	}
	
	func playRecordedAudio() {
		if !isPlaying {
			do {
				audioPlayer = try AVAudioPlayer(contentsOf: audioFileName)
				audioPlayer?.delegate = self
				isPlaying = true
				audioPlayer.prepareToPlay()
				audioPlayer.play()
				progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updatePlayTime), userInfo: nil, repeats: true)
				sliderVolume.maximumValue = maxVolume
				sliderVolume.value = 1.0
				progressView.progress = 0
				audioPlayer.volume = sliderVolume.value
			} catch {
				print("Audio player setup error: \(error.localizedDescription)")
			}
		}
		updateUIRecording(isRecording: isRecording)
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
	
	func initPlay() {
		do{
			audioPlayer = try AVAudioPlayer(contentsOf: audioFileName)
		} catch let error as NSError {
			print("Error-initPlay: \(error)")
		}
//		slVolume.maximumValue = MAX_VOLUME
		sliderVolume.value = 1.0
		progressView.progress = 0
		
		audioPlayer.delegate = self
		audioPlayer.prepareToPlay()
		audioPlayer.volume = sliderVolume.value
		
		timerLabel.text = convertNSTimeInterval2String(audioPlayer.duration)

		setPlayButton(true, stop: false)
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
	
	func convertNSTimeInterval2String(_ time: TimeInterval) -> String{
		let min = Int(time/60)
		let sec = Int(time.truncatingRemainder(dividingBy: 60))
		let strTime = String(format:"%02d:%02d", min, sec)
		return strTime
	}
	//MARK: Progress Bar Timer
	@objc func updateTimer() {
		if isRecording || isPlaying {
			// 녹음 중 또는 재생 중일 때
			let currentTime = isRecording ? audioRecorder?.currentTime : audioPlayer?.currentTime
			let formattedTime = convertNSTimeInterval2String(audioRecorder?.currentTime ?? 0)
			timerLabel.text = formattedTime
		}
	}
	
	func formatTime(seconds: Int) -> String {
		let minutes = seconds / 60
		let seconds = seconds % 60
		return String(format: "%02:%02d", minutes, seconds)
	}
	//MARK: - AddTarget: play, record, stop
	@objc func playButtonPressed(_ sender: UIButton) {
		if isPlaying {
			stopPlaying()
			startRecording()
		} else {
			playRecordedAudio()

		}
	}

	@objc func updatePlayTime(){
		timerLabel.text = convertNSTimeInterval2String(audioPlayer.currentTime)
		progressView.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
	}
	
	@objc func updateRecordTime() {
		timerLabel.text = convertNSTimeInterval2String(audioRecorder?.currentTime ?? 0)
	}
	
	@objc func tapButtonRecord(_ sender: UIButton) {
		if isRecording {
			stopRecording()

		} else {
			startRecording()
		}
	}
	
	@objc func stopButtonPressed(_ sender: UIButton) {
		stopRecording()

		timerLabel.text = convertNSTimeInterval2String(audioRecorder?.currentTime ?? 0)

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
