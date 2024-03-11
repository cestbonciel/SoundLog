//
//  CategoryIconType.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/11.
//

import UIKit
import SnapKit

enum CategoryIconType {
    case asmr
    case recording

    var title: String {
        switch self {
        case .asmr:
            return "ASMR"
        case .recording:
            return "REC"
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .asmr:
            return UIColor.vividBlueGreen // 예시 색상
        case .recording:
            return UIColor.neonPurple // 예시 색상
        }
    }
}

final class CategoryIconView: UIView {
    private let iconLabel: UILabel = {
        let label = UILabel()
        label.font = .gmsans(ofSize: 8, weight: .GMSansMedium)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    init(type: CategoryIconType) {
        super.init(frame: .zero)
        setupView(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(type: CategoryIconType) {
        self.backgroundColor = type.backgroundColor
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        addSubview(iconLabel)
        iconLabel.text = type.title
        
        iconLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4) // 상단 여백
            make.bottom.equalToSuperview().offset(-4) // 하단 여백
            make.left.equalToSuperview().offset(8) // 좌측 여백
            make.right.equalToSuperview().offset(-8) // 우측 여백
        }
    }
}
