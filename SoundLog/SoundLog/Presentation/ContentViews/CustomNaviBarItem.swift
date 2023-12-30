//
//  CustomNaviBarItem.swift
//  SoundLog
//
//  Created by Nat Kim on 2023/11/30.
//

import UIKit

struct CustomNaviBarItemConfiguration {
    typealias Action = () -> Void
    
    let image: UIImage?
    let action: Action
    
    init(image: UIImage? = nil, action: @escaping Action) {
        self.image = image
        self.action = action
    }
}

final class CustomNaviBarItem: UIButton {
    var customNaviBarItemConfig: CustomNaviBarItemConfiguration
    
    init(config: CustomNaviBarItemConfiguration) {
        self.customNaviBarItemConfig = config
        super.init(frame: .zero)
        setupStyle()
        updateConfig()
        self.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonPressed() {
        customNaviBarItemConfig.action()
    }
    
    private func setupStyle() {
        self.setPreferredSymbolConfiguration(.init(pointSize: 20), forImageIn: .normal)
        self.imageView?.tintColor = .label
    }
    
    private func updateConfig() {
        self.setImage(customNaviBarItemConfig.image, for: .normal)
    }
}

extension UIBarButtonItem {
    static func make(with config: CustomNaviBarItemConfiguration, width: CGFloat? = nil) -> UIBarButtonItem {
        let customComponent = CustomNaviBarItem(config: config)
        
        if let width = width {
            NSLayoutConstraint.activate([
                customComponent.widthAnchor.constraint(equalToConstant: width)
            ])
        }
        
        let barButtonItem = UIBarButtonItem(customView: customComponent)
        return barButtonItem
    }
}
