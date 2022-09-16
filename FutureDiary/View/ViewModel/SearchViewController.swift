//
//  SearchViewController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/13.
//

import UIKit

import RealmSwift
import Toast

class SearchViewController: UIViewController {
    
    private var datePickerView = UIPickerView()
    private var diaryAllTask: Results<Diary>!
    private var diaryTask: Results<Diary>!
    private lazy var searchedDiary = Array(diaryTask)
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let repository = RealmRepository()
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private var isSearching: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
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
        setupSearchController()
        collectionViewRegisterAndDelegate()
    }
    
    private func fetchRealm() {
        diaryTask = repository.fetch(date: Date())
        diaryAllTask = repository.fetch()
    }
    
    private func setConfigure() {
        view.backgroundColor = CustomColor.shared.backgroundColor
        
        [collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "제목으로 검색해보세요"
        navigationItem.searchController = searchController
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = CustomColor.shared.buttonTintColor
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.enablesReturnKeyAutomatically = true
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
        self.navigationItem.title = "검색하기"
        UINavigationBar.appearance().isTranslucent = false
        setNavigationColor()
    }
    
    private func collectionViewRegisterAndDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = setCollectionViewLayout()
        collectionView.register(HomeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: HomeCollectionViewCell.identifider)
    }
    
    private func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 32, right: 8)
        let width = UIScreen.main.bounds.width / 4 - spacing
        layout.itemSize = CGSize(width: width, height: width * 1.4)
        layout.headerReferenceSize = CGSize(width: view.bounds.width / 3, height: 30)
        return layout
    }
    
    private func setNavigationColor() {
        UINavigationBar.appearance().barTintColor = CustomColor.shared.buttonTintColor
        UINavigationBar.appearance().tintColor = CustomColor.shared.buttonTintColor
        self.navigationController?.navigationBar.tintColor = CustomColor.shared.buttonTintColor
        self.navigationItem.rightBarButtonItem?.tintColor = CustomColor.shared.buttonTintColor
    }
    
    private func moveToEditDiary(indexPath: IndexPath) {
        let vc = CurrentDiaryViewController()
        vc.currentTitleTextField.text = diaryTask[indexPath.row].diaryTitle
        vc.currentContentTextView.text = diaryTask[indexPath.row].diaryContent
        vc.viewModel.diaryTask = diaryTask[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isSearching ? searchedDiary.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifider, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell()}
        
        cell.diaryTitleTextLabel.text = searchedDiary[indexPath.row].diaryTitle
        cell.diaryTextView.text = searchedDiary[indexPath.row].diaryContent
        cell.diaryDateLabel.text = searchedDiary[indexPath.row].diaryDate.toDetailString
        cell.diaryDateLabel.font = .systemFont(ofSize: 10)
        cell.diaryDateLabel.textAlignment = .center
        cell.diaryDateLabel.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveToEditDiary(indexPath: indexPath)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        self.searchedDiary = self.diaryTask.filter{ $0.diaryTitle.lowercased().contains(text)}
        collectionView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        self.collectionView.reloadData()
    }
}
