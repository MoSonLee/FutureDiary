//
//  Color.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/12.
//

import UIKit

final class CustomColor {
    static let shared = CustomColor()
    private init() {}
    
    private func checkUserMode(lightModeColor: UIColor, darkModeColor: UIColor) -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .light ? lightModeColor : darkModeColor
        }
    }
    
    lazy var backgroundColor: UIColor = checkUserMode(lightModeColor: .white, darkModeColor: .black)
    lazy var textColor: UIColor = checkUserMode(lightModeColor: .black, darkModeColor: .white)
    lazy var buttonTintColor: UIColor = checkUserMode(lightModeColor: .black, darkModeColor: .white)
}
