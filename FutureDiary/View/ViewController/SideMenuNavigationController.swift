//
//  SideMenuViewController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit

final class SideMenuViewController: UIViewController {

    private let moveToSettingButton = UIButton()
    private let moveToSearchDiaryButton = UIButton()
    private let moveToDiaryCollectionButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
        setConstraints()
        moveToDiaryCollectionButton.addTarget(self, action: #selector(moveToCollectionView), for: .touchUpInside)
        moveToSettingButton.addTarget(self, action: #selector(moveToSettingView), for: .touchUpInside)
        moveToSearchDiaryButton.addTarget(self, action: #selector(moveToSearchView), for: .touchUpInside)
    }
    
    private func setConfigure() {
        [moveToSettingButton, moveToSearchDiaryButton, moveToDiaryCollectionButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.tintColor = CustomColor.shared.blackAndWhite
            $0.setTitleColor(CustomColor.shared.blackAndWhite, for: .normal)
            $0.titleLabel?.font = setCustomFont(size: 25)
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        }
        setComponentsTextAndImage()
    }
    
    private func setComponentsTextAndImage() {
        moveToDiaryCollectionButton.setTitle("moveToDiaryCollectionButton_title".localized, for: .normal)
        moveToDiaryCollectionButton.setImage(.trayFill, for: .normal)
        
        moveToSearchDiaryButton.setTitle("moveToSearchDiaryButton_title".localized, for: .normal)
        moveToSearchDiaryButton.setImage(.docTextMagnify, for: .normal)
        
        moveToSettingButton.setTitle("moveToSettingButton_title".localized, for: .normal)
        moveToSettingButton.setImage(.gear, for: .normal)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            moveToDiaryCollectionButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            moveToDiaryCollectionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            moveToSearchDiaryButton.topAnchor.constraint(equalTo: moveToDiaryCollectionButton.bottomAnchor, constant: 16),
            moveToSearchDiaryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            moveToSettingButton.topAnchor.constraint(equalTo: moveToSearchDiaryButton.bottomAnchor, constant: 16),
            moveToSettingButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        ])
    }
    
    @objc private func moveToCollectionView() {
        let vc = CollectionViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func moveToSettingView() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func moveToSearchView() {
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
