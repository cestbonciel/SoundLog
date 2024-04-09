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
            return "Recording"
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .asmr:
            return UIColor.vividBlueGreen
        case .recording:
            return UIColor.neonPurple 
        }
    }
}

final class CategoryIconView: UIView {

    private let iconLabel: UILabel = {
        let label = UILabel()
        label.font = .gmsans(ofSize: 8, weight: .GMSansMedium)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    init(type: CategoryIconType) {
        super.init(frame: .zero)
        //self.type = type
        setupView(type: type)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    func setupView(type: CategoryIconType) {
        self.backgroundColor = type.backgroundColor
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        addSubview(iconLabel)
        iconLabel.text = type.title
        
        iconLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        }
    }
    
    func updateType(type: CategoryIconType) {
        iconLabel.text = type.title
        backgroundColor = type.backgroundColor
    }
}
