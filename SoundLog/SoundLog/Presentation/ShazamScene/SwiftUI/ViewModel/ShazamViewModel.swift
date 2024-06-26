//
//  ShazamViewModel.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/11/08.
//

import Foundation
import AVKit
import ShazamKit

class ShazamViewModel: NSObject, ObservableObject {
	private var session = SHSession()
	private let audioEngine = AVAudioEngine()
    
	@Published var viewState: ViewState = .initial
    @Published var isShazamActive: Bool = false
    
	override init() {
		super.init()
		session.delegate = self
	}
	
//	func showInfo() {
//		self.viewState = .infoAlert
//	}
	
	func startListening() {
		let audioSession = AVAudioSession.sharedInstance()
		
		switch audioSession.recordPermission {
		case .undetermined:
			requestRecordPermission(audioSession: audioSession)
		case .denied:
			viewState = .recordPermissionSettingsAlert
		case .granted:
			DispatchQueue.global(qos: .background).async {
				self.proceedWithRecording()
			}
		@unknown default:
			requestRecordPermission(audioSession: audioSession)
		}
	}
	
	func stopListening() {
		//stopRecording()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        audioEngine.reset()
        try? AVAudioSession.sharedInstance().setActive(false) // Deactivate the audio session
        
        DispatchQueue.main.async {
            self.viewState = .initial // Reset the view state to the initial state
        }
	}

	private func requestRecordPermission(audioSession: AVAudioSession) {
		audioSession.requestRecordPermission { [weak self] status in
			DispatchQueue.main.async {
				if status {
					DispatchQueue.global(qos: .background).async {
						self?.proceedWithRecording()
					}
				} else {
					print("Permission denied.")
				}
			}
		}
	}
	
    private func proceedWithRecording() {
        DispatchQueue.main.async {
            self.viewState = .recordingInProgress
        }
        
        if audioEngine.isRunning {
            //stopRecording()
            stopListening()
            return
        }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: .zero)
            
            guard recordingFormat.sampleRate > 0 && recordingFormat.channelCount > 0 else {
                print("Recording format is not valid")
                return
            }
            
            inputNode.removeTap(onBus: .zero)
            inputNode.installTap(onBus: .zero, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, time in
                print("Current Recording at: \(time)")
                self?.session.matchStreamingBuffer(buffer, at: time)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Audio Engine failed to start: \(error)")
        }
	}
	
	private func stopRecording() {
		audioEngine.stop()
	}
	
}

extension ShazamViewModel: SHSessionDelegate {
	func session(_ session: SHSession, didFind match: SHMatch) {
		guard let firstMatch = match.mediaItems.first else { return }
		//stopRecording()
        stopListening()
		let song = SongData(
			title: firstMatch.title ?? "",
			artist: firstMatch.artist ?? "",
			genres: firstMatch.genres,
			artworkUrl: firstMatch.artworkURL,
			appleMusicUrl: firstMatch.appleMusicURL)
		DispatchQueue.main.async {
			self.viewState = .result(song: song)
		}
	}
	
	func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
		print(error?.localizedDescription ?? "")
		//stopRecording()
        stopListening()
		DispatchQueue.main.async {
			self.viewState = .noResult
		}
	}
}

extension ShazamViewModel {
	enum ViewState {
		case initial
		case recordingInProgress
        //case infoAlert
		case recordPermissionSettingsAlert
		case noResult
		case result(song: SongData)
	}
}
