//
//  RecordingViewController+AVFoundation.swift
//  FeatureRecording
//
//  Created by Seohyun Kim on 2023/09/16.
//

import UIKit
import AVFoundation

extension RecordingViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate {
	
	// MARK: Feature - Setup AudioRecorder
	func setupAudioRecorder() {
		
        
        let currentFileName = "your_sound_\(Date().toRecordTimeString).m4a"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.audioFileURL = documentsDirectory.appendingPathComponent(currentFileName)
		
        let audioSettings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVEncoderBitRateKey: 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100
        ]
        
		do {
			audioRecorder = try AVAudioRecorder(
                url: audioFileURL,
                settings: audioSettings
            )
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
		} catch  {
			audioRecorder = nil
            print(error.localizedDescription)
		}
	}

	
	// MARK: - functions_ Record
	@objc func startRecording(_ sender: UIButton) {
        if audioPlayer != nil && audioPlayer.isPlaying {
            print("stopping.")
            audioPlayer.stop()
        }
        
        if audioRecorder == nil {
            print("recording.. recorder nil")
            recordButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            playButton.isEnabled = false
            stopButton.isEnabled = true
            recordingWithPermission(true)
            return
        }
        
        if audioRecorder != nil && audioRecorder.isRecording  {
            audioRecorder.pause()
            recordButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        } else {
            recordButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            playButton.isEnabled = false
            stopButton.isEnabled = true
            recordingWithPermission(false)
        }
	}
	
    @objc func startPlaying(_ sender: UIButton) {
        playRecordingFile()
    }
	
    func playRecordingFile() {
        var recordedFileUrl: URL?
        
        if self.audioRecorder != nil {
            recordedFileUrl = self.audioRecorder.url
        } else {
            recordedFileUrl = self.audioFileURL!
            print("audio File URL: \(String(describing: recordedFileUrl))")
        }
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: recordedFileUrl!)
            stopButton.isEnabled = true
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 3.0
            audioPlayer.play()
            startProgressTimer()
        } catch {
            self.audioPlayer = nil
            print(error.localizedDescription)
        }
    }
    
    private func startProgressTimer() {
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self, let audioPlayer = self.audioPlayer else {
                return
            }
            self.updateUIForPlaying(with: audioPlayer)
        }
    }
    
    func updateUIForPlaying(with audioPlayer: AVAudioPlayer) {
         let currentTime = audioPlayer.currentTime
         let totalTime = audioPlayer.duration

         let progress = Float(currentTime / totalTime)
         progressView.progress = progress

         let minutes = Int(currentTime / 60)
         let seconds = Int(currentTime) % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

	func stopPlaying() {
		if isPlaying {
			audioPlayer?.stop()
			isPlaying = false
			
			progressTimer?.invalidate()
		}
	}

	
	// MARK: Feature - Play
	func setPlayButton(_ play: Bool, stop: Bool) {
		playButton.isEnabled = play
		stopButton.isEnabled = stop
	}
	// MARK: - RECORD PERMISSION
    func recordingWithPermission(_ setUp: Bool) {
        print("\(#function)")
        
        AVAudioSession.sharedInstance().requestRecordPermission { [unowned self] granted in
            if granted {
                DispatchQueue.main.async {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setUp {
                        self.setupAudioRecorder()
                    }
                    self.audioRecorder.record()
                    self.progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
                        self.updateAudioMeter(timer: timer)
                    })
                    
                }
            } else {
                print("Permission to record not granted.")
            }
        }
        
        if AVAudioSession.sharedInstance().recordPermission == .denied {
            print("permission denied.")
        }
    }
    
    private func updateAudioMeter(timer: Timer) {
        if let recorder = self.audioRecorder {
            if recorder.isRecording {
                let min = Int(recorder.currentTime / 60)
                let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
                let progressTimer = String(format: "%02d:%02d", min, sec)
                timerLabel.text = progressTimer
                audioRecorder.updateMeters()
            }
        }
    }
    
    func setSessionPlayback() {
        print("\(#function)")
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSession.Category.playback, mode: .default)
            
        } catch {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(
                AVAudioSession.Category.playAndRecord,
                options: .defaultToSpeaker
            )
        } catch {
            print("could not set session category.")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("could not make session active.")
            print(error.localizedDescription)
        }
        
    }
	//MARK: Progress Bar Timer
	
	func formatTime(_ time: TimeInterval) -> String {
		let min = Int(time / 60)

		let sec = Int(time.truncatingRemainder(dividingBy: 60))

		let strTime = String(format: "%02d:%02d", min, sec)
		return strTime
	}
	//MARK: - ADD TARGET : PLAY

	@objc func updatePlayTime(){
		timerLabel.text = formatTime(audioPlayer.currentTime)
		progressView.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
	}

	
	@objc func stopButtonPressed(_ sender: UIButton) {
        audioRecorder?.stop()
        audioPlayer?.stop()
        progressTimer.invalidate()
        
        recordButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            playButton.isEnabled = true
            stopButton.isEnabled = false
            recordButton.isEnabled = true
        } catch {
            print("Could not make session inactive.")
            print(error.localizedDescription)
        }
        
	}
	
	// MARK: - AVFoundation Delegate
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("function: \(#function)")
        
        print("finished recording \(flag)")
        stopButton.isEnabled = false
        playButton.isEnabled = true
        recordButton.setImage(UIImage(systemName: "mic.fill"), for: UIControl.State())
        
        let alert = UIAlertController(title: "소리의 기록",
                                      message: "녹음이 완료됐어요.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "녹음유지", style: .default) {[unowned self] _ in
            print("keep was tapped")
            self.audioRecorder = nil
        })
        alert.addAction(UIAlertAction(title: "지우기", style: .destructive) {[unowned self] _ in
             print("delete was tapped")
             self.audioRecorder.deleteRecording()
        })
        
        if flag {
            self.audioFileURL = recorder.url

        }
        self.present(alert, animated: true, completion: nil)
	}
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("Playing finished \(flag)")
            self.statePlaying = false

            recordButton.isEnabled = true
            stopButton.isEnabled = false
            progressView.setProgress(0.0, animated: false)
            timerLabel.text = "00:00"
        } else {
            print("Playing failed.")
        }
        stopPlaying()
        progressTimer?.invalidate()
        
    }
}
