//
//  LocalizationViewController.swift
//  SoundLog
//
//  Created by Nat Kim on 2023/12/11.
//

import UIKit

class LocalizationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    let label: UILabel = {
        let label = UILabel()
        
        label.text = "다국어"
        label.textColor = .label
        label.font = .gmsans(ofSize: 30, weight: .GMSansBold)
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .label
        button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
        button.layer.borderColor = UIColor.magenta.cgColor
        button.layer.borderWidth = 1
        button.frame = CGRect(x: 340, y: 16, width: 32, height: 32)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    private func setupUI() {
        view.addSubview(label)
        view.addSubview(closeButton)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -48),
            closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48)
        ])
    }

}
