//
//  SoundLogView.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/14.
//

import UIKit

import SnapKit

final class SoundLogView: UIView, UIScrollViewDelegate {
    private let soundLogTextView = LogTextView()
    //private let customPlayerView = CustomPlayerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Entire View Scroll
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Buttons: save, cancel
    lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 72, height: 40)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        button.setTitle("취소", for: .normal)
        return button
    }()
    // MARK: - Save 녹음 일기 ⭐️
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 72, height: 40)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.neonYellow
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        
        return button
    }()
    
    // MARK: - Common background  ( 나중에 컴포넌트화 하자)
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Date
    lazy var soundLogDate: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .dateAndTime
        picker.date = Date()
        picker.locale = Locale(identifier: "ko_KR")
        picker.timeZone = .autoupdatingCurrent
        picker.tintColor = .neonPurple
        picker.contentHorizontalAlignment = .center
        
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .automatic
        } else {
            picker.preferredDatePickerStyle = .wheels
        }
        return picker
    }()
    
   
    // MARK: - Diary Forms
    lazy var soundLogTitle: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 48))
        
        
        let leftInsetView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 48))
        textField.leftView = leftInsetView
        textField.leftViewMode = .always
        textField.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        textField.attributedPlaceholder = NSAttributedString(string: "3자 이상 7자 미만", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
        
        textField.layer.cornerRadius = 10
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        
        textField.returnKeyType = .done
//        textField.delegate = self
        textField.layer.backgroundColor = UIColor.white.cgColor
        
        return textField
    }()
    
    lazy var backgroundView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        return view
    }()
    
    //MARK: - Choose mood
    lazy var moodStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    lazy var moodButtons: [UIButton] = {
        var buttons = [UIButton]()
        let mood = [1: "기분", 2: "😁", 3: "😡", 4: "😭", 5: "😍"]
        for (index, moodText) in mood.sorted(by: {  $0.key < $1.key }) {
            let button = UIButton()
            button.tag = index
            button.setTitle("\(moodText)", for: .normal)
            button.setTitleColor(.black, for: .normal)
            
            button.titleLabel?.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
            
            buttons.append(button)
        }
        return buttons
    }()

    // MARK: - Feature : Recording
    private lazy var backgroundView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backgroundView4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var backgroundView5: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var recordingStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recordLabel, recordingButton])

        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var recordLabel: UILabel = {
        let label = UILabel()
        label.text = "당신의 소리를 기록해보세요."
        label.numberOfLines = 0
        label.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        
        return label
    }()
    
    lazy var recordingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "waveform.circle.fill"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
        button.tintColor = .black
        //button.addTarget(self, action: #selector(touchUpbottomSheet), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LOCATION STACK VIEW
    lazy var locationStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationLabel, coreLocationButton])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        label.text = "어디서 기록했나요?"
        return label
    }()
    
    lazy var coreLocationButton: UIButton = {
        let button = UIButton()
        //location.fill
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.setPreferredSymbolConfiguration(.init(pointSize: 32, weight: .regular, scale: .default), forImageIn: .normal)
        button.tintColor = .black
        button.tintColor = .black
        return button
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        label.text = "카테고리 선택"
        return label
    }()
    
    lazy var categoryBtnStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [selectedRecBtn, selectedASMRBtn])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var selectedButton: UIButton?
    
    lazy var selectedRecBtn: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 56, height: 32)
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.setTitle("녹음", for: .normal)
        button.titleLabel?.font = .gmsans(ofSize: 12, weight: .GMSansMedium)
        return button
    }()
    
    lazy var selectedASMRBtn: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 56, height: 32)
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.setTitle("ASMR", for: .normal)
        button.titleLabel?.font = .gmsans(ofSize: 12, weight: .GMSansMedium)
        return button
    }()

    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .gmsans(ofSize: 12, weight: .GMSansMedium)
        return label
    }()
    
    // MARK: - setupUI
    private func setupUI() {
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(800)
        }
        
        contentView.addSubview(buttonStack)
        buttonStack.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).inset(48)
            $0.leading.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints {
            $0.width.equalTo(72)
            $0.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints {
            $0.width.equalTo(72)
            $0.height.equalTo(40)
        }
        
        contentView.addSubview(backgroundView)
        backgroundView.addSubview(soundLogDate)
        
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(buttonStack.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(48)
        }
        
        soundLogDate.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        contentView.addSubview(soundLogTitle)
        soundLogTitle.snp.makeConstraints{
            $0.top.equalTo(backgroundView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(48)
        }
        //MARK: - moodButton Autolayout
        contentView.addSubview(backgroundView2)
        backgroundView2.snp.makeConstraints {
            $0.top.equalTo(soundLogTitle.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(48)
        }
        backgroundView2.addSubview(moodStackView)
        moodStackView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(4)
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        for button in moodButtons {
            moodStackView.addArrangedSubview(button)
        }
        
        for (_, button) in moodButtons.enumerated() {
            button.snp.makeConstraints {
                $0.height.equalTo(32)
            }
        }
        
        //MARK: - Recording StackView

        contentView.addSubview(backgroundView3)
        backgroundView3.addSubview(recordingStack)
        backgroundView3.snp.makeConstraints {
            $0.top.equalTo(backgroundView2.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(48)
        }
        
        recordingStack.snp.makeConstraints{
            $0.centerY.equalTo(backgroundView3.snp.centerY)
            $0.leading.equalTo(backgroundView3.snp.leading).inset(16)
            $0.trailing.equalTo(backgroundView3.snp.trailing).inset(16)
        }
        recordLabel.snp.makeConstraints {
            $0.centerY.equalTo(recordingStack.snp.centerY)
        }
        
        recordingButton.snp.makeConstraints {
            $0.centerY.equalTo(recordingStack.snp.centerY)
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }
        
        
        // MARK: - UITextView
        soundLogTextView.placeholderText = "소리에 대해 작성해봐요."
        contentView.addSubview(soundLogTextView)

        soundLogTextView.snp.makeConstraints {
            $0.top.equalTo(recordingStack.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(28)
            $0.height.equalTo(180)
        }

        // MARK: - USER LOCATION
        contentView.addSubview(backgroundView4)
        backgroundView4.addSubview(locationStack)
        contentView.addSubview(addressLabel)
        
        backgroundView4.snp.makeConstraints {
            $0.top.equalTo(soundLogTextView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(28)
            $0.height.equalTo(48)
        }
        
        locationStack.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(16)
        }

        locationLabel.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalTo(locationStack.snp.centerY)
        }
        
        coreLocationButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(locationStack.snp.top).offset(56)
            $0.right.equalTo(coreLocationButton.snp.right)
        }
       
        
        contentView.addSubview(backgroundView5)
        backgroundView5.addSubview(categoryLabel)
        backgroundView5.addSubview(categoryBtnStack)

        
        backgroundView5.snp.makeConstraints {
            $0.top.equalTo(backgroundView4.snp.bottom).offset(56)
            $0.left.right.equalToSuperview().inset(28)
            $0.height.equalTo(48)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(backgroundView5.snp.leading).inset(20)
            $0.centerY.equalTo(backgroundView5.snp.centerY)
            $0.width.equalTo(198)
            $0.height.equalTo(40)
        }
        
        categoryBtnStack.snp.makeConstraints {
            $0.trailing.equalTo(backgroundView5.snp.trailing).inset(16)
            $0.centerY.equalTo(backgroundView5.snp.centerY)
            $0.width.equalTo(134)
        }
        
        selectedRecBtn.snp.makeConstraints {
            $0.width.equalTo(56)
            $0.height.equalTo(32)
        }
        
        selectedASMRBtn.snp.makeConstraints {
            $0.width.equalTo(56)
            $0.height.equalTo(32)
        }
        
    }// : setupUI
}


