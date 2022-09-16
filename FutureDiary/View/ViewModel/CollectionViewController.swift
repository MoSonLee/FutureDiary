//
//  CollectionViewController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/13.
//

import UIKit

import RealmSwift
import Toast

class CollectionViewController: UIViewController {
    private var datePickerView = UIPickerView()
    private var diaryAllTask: Results<Diary>!
    private var diaryTask: Results<Diary>!
    private var mailButton = UIBarButtonItem()
    private var diaryDictionary: [String : [Diary]] = [ : ]
    private lazy var diarySortedKey = diaryDictionary.keys.sorted(by: >)
    
    private let repository = RealmRepository()
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
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
    }
    
    private func fetchRealm() {
        diaryTask = repository.fetch(date: Date())
        diaryAllTask = repository.fetch()
        diaryTask.forEach { value in
            diaryDictionary[value.diaryDate.toString] = Array(diaryTask.filter{ $0.diaryDate.toString == value.diaryDate.toString })
        }
        collectionView.reloadData()
    }
    
    private func setConfigure() {
        view.backgroundColor = CustomColor.shared.backgroundColor
        [collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setNavigation() {
        self.navigationItem.title = "보관함"
        UINavigationBar.appearance().isTranslucent = false
        mailButton = UIBarButtonItem(image: UIImage(systemName: "signpost.right.fill"), style: .done, target: self, action: #selector(showToastMessage))
        self.navigationItem.rightBarButtonItem = mailButton
        setNavigationColor()
    }
    
    private func collectionViewRegisterAndDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = setCollectionViewLayout()
        collectionView.register(HomeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: HomeCollectionViewCell.identifider)
        collectionView.register(CollectionHeaderReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderReusableView.identifier)
    }
    
    private func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        layout.sectionInset = UIEdgeInsets(top: 32, left: 8, bottom: 32, right: 8)
        let width = UIScreen.main.bounds.width / 4 - spacing
        layout.itemSize = CGSize(width: width, height: width * 1.4)
        layout.headerReferenceSize = CGSize(width: view.bounds.width / 2, height: 30)
        return layout
    }
    
    private func setNavigationColor() {
        UINavigationBar.appearance().barTintColor = CustomColor.shared.buttonTintColor
        UINavigationBar.appearance().tintColor = CustomColor.shared.buttonTintColor
        self.navigationController?.navigationBar.tintColor = CustomColor.shared.buttonTintColor
        self.navigationItem.rightBarButtonItem?.tintColor = CustomColor.shared.buttonTintColor
    }
    
    @objc func showToastMessage() {
        view.makeToast("도착 예정 편지는 \(diaryAllTask.count - diaryTask.count)개입니다!")
    }
    
    private func moveToEditDiary(indexPath: IndexPath) {
        
        let key = diarySortedKey[indexPath.section]
        guard let diary = diaryDictionary[key]?[indexPath.item] else { return  }
        
        let vc = CurrentDiaryViewController()
        vc.currentTitleTextField.text = diary.diaryTitle
        vc.currentContentTextView.text = diary.diaryContent
        vc.viewModel.diaryTask = diary
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        diarySortedKey.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderReusableView.identifier, for: indexPath) as? CollectionHeaderReusableView else { return UICollectionReusableView()}
        
        headerView.headerLabel.backgroundColor = CustomColor.shared.backgroundColor
        headerView.headerLabel.textColor = CustomColor.shared.textColor
        headerView.headerLabel.text = diarySortedKey[indexPath.section]
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = diarySortedKey[section]
        return diaryDictionary[key]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveToEditDiary(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifider, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell()}
        
        let key = diarySortedKey[indexPath.section]
        guard let diary = diaryDictionary[key]?[indexPath.item] else { return UICollectionViewCell() }
        
        cell.diaryTitleTextLabel.text = diary.diaryTitle
        cell.diaryTextView.text = diary.diaryContent
        cell.diaryDateLabel.text = diary.diaryDate.toDetailString
        
        return cell
    }
}
