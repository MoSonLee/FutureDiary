//
//  CollectionViewController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/13.
//

import UIKit

class CollectionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
        setConstraints()
        setNavigation()
    }
    
    private func setConfigure() {
        view.backgroundColor = CustomColor.shared.backgroundColor
    }
    
    private func setConstraints() {
        
    }
    
    private func setNavigation() {
        self.navigationItem.title = "보관함"
        UINavigationBar.appearance().isTranslucent = false
        setNavigationColor()
    }
    
    private func setNavigationColor() {
        UINavigationBar.appearance().barTintColor = CustomColor.shared.buttonTintColor
        UINavigationBar.appearance().tintColor = CustomColor.shared.buttonTintColor
        self.navigationController?.navigationBar.tintColor = CustomColor.shared.buttonTintColor
        self.navigationItem.rightBarButtonItem?.tintColor = CustomColor.shared.buttonTintColor
    }
}
