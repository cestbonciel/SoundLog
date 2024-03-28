//
//  CustomPlayerView.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/04.
//

import UIKit
import AVFoundation

import SnapKit

class CustomPlayerView: UIView {
    // 추가된 부분: 플레이어 상태 열거형
    enum PlayerState {
        case playing, paused
    }
    
    // 추가된 부분: 현재 플레이어 상태
    var currentPlayerState: PlayerState = .paused {
        didSet {
            setButtonState()
        }
    }
    
    var audioPlayer: AVAudioPlayer?
    var audioTimer: Timer?
    
    init() {
        super.init(frame: .zero)
        setupUI()
        makeTimer()
    }
    
    convenience init(url: URL) {
        self.init()
        setupUI()
        queueSound(url: url)
        makeTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var playerBGView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemDimGray.withAlphaComponent(0.4)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.bgGray.cgColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    lazy var playAndPauseBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 16, weight: .regular, scale: .default), forImageIn: .normal)

        button.tintColor = .black
        button.addTarget(self, action: #selector(playbuttonTapped), for: .touchUpInside)
        return button
    }()
   
    private var audioPlayTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        
        return label
    }()
    

    private lazy var playStateBar: UIProgressView = {
        let progress = UIProgressView()
        progress.setProgress(0.0, animated: true)
        progress.tintColor = UIColor.neonPurple
        progress.trackTintColor = UIColor.white
        return progress
    }()
    
    func setupAudioSessionForPlayback() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default)
        } catch {
            print("Failed to set up audio session for playback: \(error.localizedDescription)")
        }
    }
    
    private func setButtonState() {

        switch currentPlayerState {
        case .playing:
            playAndPauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        case .paused:
            playAndPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    @objc func playbuttonTapped() {
        guard let player = audioPlayer else {
            print("audioPlayer 인스턴스가 없습니다.")
            return
        }

        if player.isPlaying {
            currentPlayerState = .paused
            player.pause()
            print("재생이 일시 정지되었습니다.")
        } else {
            currentPlayerState = .playing
            player.play()
            print("재생이 시작되었습니다.")
        }
    }
    /*
    @objc func playbuttonTapped() {

        if currentPlayerState == .playing {
            currentPlayerState = .paused
            audioPlayer?.pause()
        } else {
            currentPlayerState = .playing
            audioPlayer?.play()
        }
    }
    */
    private func makeTimer() {
        if audioTimer != nil {
            audioTimer!.invalidate()
        }
        audioTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updatePlayTime),
            userInfo: nil,
            repeats: true
        )
    }
    
    // TODO: - 녹음된 파일 전달되어야 하는 메소드
    func queueSound(url: URL) {
        setupAudioSessionForPlayback()
        do {
            let isFileExists = FileManager.default.fileExists(atPath: url.path)
            print("@@@ 파일 존재여부: \(isFileExists) @@@")
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            if !isFileExists {
                print("Error: 파일이 존재하지 않습니다.")
            }
        } catch {
            print("Error AudioPlayer: \(error.localizedDescription)")
        }
    }

    @objc private func updatePlayTime() {
        guard let player = audioPlayer else { return }
        audioPlayTimeLabel.text = formatTimeInterval2String(player.currentTime)
        playStateBar.progress = Float(player.currentTime / player.duration)
    }
    
    private func formatTimeInterval2String(_ time: TimeInterval) -> String {
        let mins = Int(time / 60)
        let secs = Int(time.truncatingRemainder(dividingBy: 60))
        let formattedTime = String(format: "%02d:%02d", mins, secs)
        return formattedTime
    }
    
    
    
    private func setupUI() {
        self.addSubview(playerBGView)
        playerBGView.addSubview(playAndPauseBtn)
        playerBGView.addSubview(audioPlayTimeLabel)
        playerBGView.addSubview(playStateBar)
       
        playerBGView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(32)
        }
        
        playAndPauseBtn.snp.makeConstraints {
            $0.centerY.equalTo(playerBGView.snp.centerY)
            $0.left.equalToSuperview().inset(16)
        }
        
        audioPlayTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(playerBGView.snp.centerY)
            $0.left.equalTo(playAndPauseBtn.snp.right).offset(8)
        }
        
        playStateBar.snp.makeConstraints {
            $0.centerY.equalTo(playerBGView.snp.centerY)
            $0.left.equalTo(audioPlayTimeLabel.snp.right).offset(8)
            $0.right.equalToSuperview().inset(16)
        }
    }
}

extension CustomPlayerView: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            currentPlayerState = .paused
            setButtonState()
        } else {
            print("Error: Audio playback finished unsuccessfully.")
        }
    }
}
