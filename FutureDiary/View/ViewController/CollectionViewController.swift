//
//  CollectionViewController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/13.
//

import UIKit

import RealmSwift
import Toast

final class CollectionViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private var datePickerView = UIPickerView()
    private var mailButton = UIBarButtonItem()
    private var diaryDictionary: [String : [Diary]] = [ : ]
    private var diarySortedKey: [String] = []
    
    private let repository = RealmRepository()
    private var diaryAllTask: Results<Diary>!
    private var diaryTask: Results<Diary>!
    
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
        diaryDictionary = [ : ]
        diaryTask = repository.fetch(date: Date())
        diaryAllTask = repository.fetch()
        diaryTask.forEach { value in
            diaryDictionary[value.diaryDate.toString] = Array(diaryTask.filter{ $0.diaryDate.toString == value.diaryDate.toString })
        }
        diarySortedKey = diaryDictionary.keys.sorted(by: >)
        collectionView.reloadData()
    }
    
    private func setConfigure() {
        view.backgroundColor = UIColor(patternImage:  .backgroundImage)
        collectionView.backgroundColor = .clear
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
        self.navigationItem.title = "storage".localized
        mailButton = UIBarButtonItem(image: .signpost, style: .done, target: self, action: #selector(showToastMessage))
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
    
    @objc private func showToastMessage() {
        view.makeToast("collection_toast_head".localized(number: diaryAllTask.count - diaryTask.count))
    }
    
    private func moveToEditDiary(indexPath: IndexPath) {
        let vc = CurrentDiaryViewController()
        let key = diarySortedKey[indexPath.section]
        guard let diary = diaryDictionary[key]?[indexPath.item] else { return  }
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
        headerView.setConfigureHeader(diaryDic: diarySortedKey, indexPath: indexPath)
        headerView.headerLabel.font = setCustomFont(size: 25)
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
        cell.configureCollectionViewCell(diary: diary)
        return cell
    }
}
