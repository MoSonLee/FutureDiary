//
//  VersionViewController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/18.
//

import UIKit

final class VersionViewController: UIViewController {
    
    private let versionImageView = UIImageView()
    private let versionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
        setConstaints()
    }
    
    private func setConfigure() {
        view.backgroundColor = CustomColor.shared.backgroundColor
        
        [versionImageView, versionLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        versionImageView.image = UIImage(named: "mail")
        versionLabel.text = "버전 1.0.0"
        versionLabel.textColor = CustomColor.shared.textColor
    }
    
    private func setConstaints() {
        NSLayoutConstraint.activate([
            versionImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            versionImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            versionImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            versionImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            versionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
}
