//
//  SplashViewController.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/22.
//

import UIKit

import Lottie
import SnapKit

final class SplashViewController: UIViewController {
    
    //var animationView: LottieAnimationView?
    @IBOutlet weak var appNameSoundLog: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.changeTextColor()
        setSplashAnimation()
    }
    
    func setSplashAnimation() {
        let animationView: LottieAnimationView = .init(name: "soundLogBlue")
        view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.centerX.equalTo(appNameSoundLog.snp.centerX)
            $0.top.equalToSuperview().offset(100)
        }
        animationView.play { [weak self] (finished) in
            if finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.transitionToMainViewController()
                }
            }
        }
        animationView.alpha = 0.5
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1
        
        view.bringSubviewToFront(appNameSoundLog)
    }
    
    func transitionToMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBar") as? MainTabBarController else { return }
        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: false)
    }
    
    func changeTextColor() {
        guard let text = self.appNameSoundLog.text else { return }
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor(displayP3Red: 149/255, green: 146/255, blue: 230/255, alpha: 1), range: (text as NSString).range(of: "소"))
        attributeString.addAttribute(.foregroundColor, value: UIColor(displayP3Red: 149/255, green: 146/255, blue: 230/255, alpha: 1), range: (text as NSString).range(of: "기"))
        self.appNameSoundLog.attributedText = attributeString
    }
}
