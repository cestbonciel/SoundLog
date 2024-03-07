//
//  ProfileDetailView.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/08.
//

import UIKit

final class ProfileDetailView: UIView {
    var viewModel = ProfileViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProfileView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var popView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.systemDimGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var nickTitle: UILabel = {
        let label = UILabel()
        label.text = "닉네임변경"
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .black

        return label
    }()
    
    private let usernameValidationLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemRed

        return label
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 48))
        
        let leftInsetView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 48))
        textField.leftView = leftInsetView
        textField.leftViewMode = .always
        textField.font = .gmsans(ofSize: 12, weight: .GMSansMedium)
        textField.attributedPlaceholder = NSAttributedString(string: "닉네임 입력", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
        
        textField.layer.borderColor = UIColor.systemDimGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        
        textField.returnKeyType = .done
        textField.delegate = self
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textDidChaged), for: .editingChanged)
        return textField
    }()
    
    @objc func textDidChaged(sender: UITextField) {
        if sender.text?.count == 1 {
            if sender.text?.first == " " {
                sender.text = ""
                return
            }
        }
        
        if sender == nicknameTextField {
            viewModel.username = sender.text ?? ""
            usernameValidationLabel.text = viewModel.usernameValidationLabelText
        }
    }
    
    private lazy var modiButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 48, height: 32)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.neonPurple

        button.setTitle("수정", for: .normal)
        button.titleLabel?.font = .gmsans(ofSize: 12, weight: .GMSansMedium)
        
        return button
    }()
    
    private func setupProfileView() {
        addSubview(popView)
        popView.addSubview(nickTitle)
        popView.addSubview(nicknameTextField)
        popView.addSubview(usernameValidationLabel)
        popView.addSubview(modiButton)
        
        popView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(65)
            //$0.centerY.equalToSuperview()
        }
        
        nickTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nickTitle.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        usernameValidationLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField).offset(16)
            $0.centerX.equalTo(nicknameTextField.snp.centerX)
        }
        
        modiButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }
        
        
    }
}

extension ProfileDetailView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
