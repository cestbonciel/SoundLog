//
//  SoundLogDetailView.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/15.
//

import UIKit

import SnapKit

final class SoundLogDetailView: UIView, UIScrollViewDelegate {
    var soundLog: StorageSoundLog?
    
    //var customPlayerView: CustomPlayerView?
    
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
    
    lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, rightButtonStack])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    //MARK: - Buttons: edit, delete
    lazy var rightButtonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [deleteButton, editButton])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 56, height: 40)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        button.setTitle("취소", for: .normal)
        return button
    }()
    // MARK: - Save 녹음 일기 ⭐️
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 56, height: 40)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.dimRed
        button.setTitle("삭제", for: .normal)
        button.titleLabel?.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        
        return button
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 56, height: 40)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.setTitle("수정", for: .normal)
        button.titleLabel?.font = .gmsans(ofSize: 16, weight: .GMSansBold)
        
        return button
    }()
    
    // MARK: - Common background  ( 나중에 컴포넌트화 하자)
    private lazy var backgroundView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 217.0 / 255.0, green: 229.0 / 255.0, blue: 229.0 / 255.0, alpha: 1)
        view.backgroundColor = .pastelSkyblue
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
        textField.attributedPlaceholder = NSAttributedString(string: "1자 이상 24자 미만", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
        
        textField.layer.cornerRadius = 10
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        
        textField.returnKeyType = .done
        textField.layer.backgroundColor = UIColor.pastelSkyblue.cgColor
        
        return textField
    }()
    
    lazy var backgroundView2: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 217.0 / 255.0, green: 229.0 / 255.0, blue: 229.0 / 255.0, alpha: 0.5)
        view.backgroundColor = .pastelSkyblue
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
        let moodLabelButton = UIButton()
        moodLabelButton.setTitle("기분", for: .normal)
        moodLabelButton.setTitleColor(.black, for: .normal)
        moodLabelButton.isEnabled = false
        moodLabelButton.titleLabel?.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
        buttons.append(moodLabelButton)
        
        for (index, emojiString) in MoodEmoji.emojis.enumerated() where index != 0 {
            
            let button = UIButton()
            button.tag = index
            button.setTitle(emojiString, for: .normal)
            button.setTitleColor(.black, for: .normal)
            
            button.titleLabel?.font = .gmsans(ofSize: 16, weight: .GMSansMedium)
            button.layer.cornerRadius = button.frame.size.height / 2
            button.clipsToBounds = true
            buttons.append(button)
        }
        
        return buttons
    }()

    // MARK: - Feature : Recording
    private lazy var backgroundView3: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 217.0 / 255.0, green: 229.0 / 255.0, blue: 229.0 / 255.0, alpha: 0.5)
        view.backgroundColor = .pastelSkyblue
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var backgroundView4: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 217.0 / 255.0, green: 229.0 / 255.0, blue: 229.0 / 255.0, alpha: 0.5)
        view.backgroundColor = .pastelSkyblue
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var backgroundView5: UIView = {
        let view = UIView()
        view.backgroundColor = .pastelSkyblue
        //view.backgroundColor = UIColor(red: 217.0 / 255.0, green: 229.0 / 255.0, blue: 229.0 / 255.0, alpha: 0.5)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
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
    
    // 저장 버튼 상태를 업데이트하는 메소드
    func updateEditButton(isEnabled: Bool) {
        editButton.isEnabled = isEnabled
        editButton.backgroundColor = isEnabled ? UIColor.neonYellow : UIColor.lightGray
        
        let fontColor: UIColor = isEnabled ? .black : .gray
        editButton.setTitleColor(fontColor, for: .normal)
    }
    
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
            $0.left.equalToSuperview().inset(28)
            $0.right.equalToSuperview().inset(28)
            $0.height.equalTo(40)
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalTo(72)
            $0.height.equalTo(40)
        }
//        contentView.addSubview(rightButtonStack)
        rightButtonStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            //$0.left.equalTo(cancelButton.snp.right).offset(148)
            $0.right.equalToSuperview()
            $0.width.equalTo(126)
            $0.height.equalTo(40)
        }

        editButton.snp.makeConstraints {
            $0.width.equalTo(72)
            $0.height.equalTo(40)
        }
        
        deleteButton.snp.makeConstraints {
            $0.width.equalTo(72)
            $0.height.equalTo(40)
        }
        
        contentView.addSubview(backgroundView)
        backgroundView.addSubview(soundLogDate)
        
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(rightButtonStack.snp.bottom).offset(24)
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
        

        // MARK: - USER LOCATION
        contentView.addSubview(backgroundView4)
        backgroundView4.addSubview(locationStack)
        contentView.addSubview(addressLabel)
        
        backgroundView4.snp.makeConstraints {
            $0.top.equalTo(backgroundView3.snp.bottom).offset(24)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        moodButtons.forEach { button in
            button.layer.cornerRadius = button.bounds.size.height / 2
            button.clipsToBounds = true
        }
    }
}
