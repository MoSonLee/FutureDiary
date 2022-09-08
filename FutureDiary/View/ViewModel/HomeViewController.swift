//
//  HomeViewController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit

import RxCocoa
import RxSwift
import SideMenu

final class HomeViewController: UIViewController {
    
    lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private lazy var bottomView = UIView()
    private lazy var moveToHomeDiaryButton = UIButton()
    private lazy var moveToFutureDiaryButton = UIButton()
    private let appearance = UINavigationBarAppearance()
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
        setConstraints()
        setNavigation()
        collectionViewRegisterAndDelegate()
        moveToHomeDiaryButton.addTarget(self, action: #selector(moveToCurrnetDiary), for: .touchUpInside)
        moveToFutureDiaryButton.addTarget(self, action: #selector(moveToFutureDiary), for: .touchUpInside)
    }
    
    private func setConfigure() {
        collectionView.collectionViewLayout = setCollectionViewLayout()
        
        collectionView.register(
            HomeCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeCollectionViewCell.identifider)
    }
    
    private func setConstraints() {
        [collectionView, bottomView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [moveToHomeDiaryButton, moveToFutureDiaryButton].forEach {
            bottomView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.tintColor = .white
        }
        
        bottomView.backgroundColor = .systemGray
        collectionView.backgroundColor = .systemGray
        
        bottomView.layer.borderWidth = 0.5
        bottomView.layer.borderColor = UIColor.white.cgColor
        
        moveToHomeDiaryButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        moveToFutureDiaryButton.setImage(UIImage(systemName: "tray.full.fill"), for: .normal)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            bottomView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            moveToHomeDiaryButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            moveToHomeDiaryButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 80),
            
            moveToFutureDiaryButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            moveToFutureDiaryButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -80)
        ])
    }
    
    private func collectionViewRegisterAndDelegate() {
        collectionView.register(HomeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: HomeCollectionViewCell.identifider)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setNavigation() {
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemFill
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.circle"), style: .done, target: self, action: #selector(method))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar.circle"), style: .done, target: self, action: #selector(method))
        self.navigationController?.navigationBar.topItem?.title = "FURY"
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 239/255, green: 210/255, blue: 166/255, alpha: 1.0)
    }
    
    private func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let width = UIScreen.main.bounds.width / 3 - spacing
        layout.itemSize = CGSize(width: width, height: width * 1.4)
        return layout
    }
    
    @objc func moveToCurrnetDiary() {
        let vc = CurrentDiaryViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .crossDissolve
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true)
    }
    
    @objc func moveToFutureDiary() {
        let vc = FutureDiaryController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .crossDissolve
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifider, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell()}
        return cell
    }
}
