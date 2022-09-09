//
//  HomeViewController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift
import SideMenu

final class HomeViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let bottomView = UIView()
    private let moveToHomeDiaryButton = UIButton()
    private let moveToFutureDiaryButton = UIButton()
    private let appearance = UINavigationBarAppearance()
    private let viewModel = HomeViewModel()
    private let repository = RealmRepository()
    private let localRealm = try! Realm()
    
    private var diaryTask: Results<Diary>! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRealm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
        setConstraints()
        setNavigation()
        collectionViewRegisterAndDelegate()
        moveToHomeDiaryButton.addTarget(self, action: #selector(moveToCurrnetDiary), for: .touchUpInside)
        moveToFutureDiaryButton.addTarget(self, action: #selector(moveToFutureDiary), for: .touchUpInside)
    }
    
    private func fetchRealm() {
        diaryTask = repository.fetch(today: Date())
        collectionView.reloadData()
    }
    
    private func setConfigure() {
        collectionView.collectionViewLayout = setCollectionViewLayout()
        collectionView.register(
            HomeCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeCollectionViewCell.identifider)
    }
    
    @objc private func setSideMenu() {
        let menu = SideMenuNavigationController(rootViewController: SideMenuViewController())
        menu.leftSide = true
        menu.blurEffectStyle = .systemChromeMaterialDark
        menu.presentationStyle = .viewSlideOutMenuIn
        present(menu, animated: true, completion: nil)
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
        
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.circle"), style: .done, target: self, action: #selector(setSideMenu))
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moveToFutureDiary() {
        let vc = FutureDiaryController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        diaryTask.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifider, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell()}
        cell.currentTitleTextLabel.text = diaryTask[indexPath.row].diaryTitle
        cell.currentTextView.text = diaryTask[indexPath.row].diaryContent
        return cell
    }
}
