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
    lazy var blackAndWhite: UIColor = checkUserMode(lightModeColor: .black, darkModeColor: .white)
    lazy var whiteAndBlack: UIColor = checkUserMode(lightModeColor: .white, darkModeColor: .black)
    lazy var blackAndGray: UIColor = checkUserMode(lightModeColor: .black, darkModeColor: .systemGray)
    lazy var sideMenuColor: UIColor = checkUserMode(lightModeColor: .white, darkModeColor: .systemGray6)
}

