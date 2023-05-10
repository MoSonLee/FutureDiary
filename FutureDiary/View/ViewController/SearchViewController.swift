//
//  SearchViewController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/13.
//

import UIKit

import RealmSwift
import Toast

final class SearchViewController: UIViewController {
    
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
        view.backgroundColor = UIColor(patternImage:  .backgroundImage)
        collectionView.backgroundColor = .clear
        [collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "moveToSearchDiaryButton_title".localized
        navigationItem.searchController = searchController
        searchController.searchBar.setValue("cancel_title".localized, forKey: "cancelButtonText")
        searchController.searchBar.tintColor = CustomColor.shared.blackAndWhite
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.obscuresBackgroundDuringPresentation = false
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
        self.navigationItem.title = "moveToSearchDiaryButton_title".localized
        setNavigationColor()
    }
    
    private func collectionViewRegisterAndDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = setCollectionViewLayout()
        collectionView.register(HomeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: HomeCollectionViewCell.identifider)
    }
    
    private func moveToEditDiary(indexPath: IndexPath) {
        let vc = CurrentDiaryViewController()
        vc.currentTitleTextField.text = searchedDiary[indexPath.row].diaryTitle
        vc.currentContentTextView.text = searchedDiary[indexPath.row].diaryContent
        vc.viewModel.diaryTask = searchedDiary[indexPath.row]
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
        
        cell.configureSearchCollectionViewCell(searchedDiary: searchedDiary, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveToEditDiary(indexPath: indexPath)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) {  _ in
            self.collectionView.collectionViewLayout = self.setCollectionViewLayout()
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        self.searchedDiary = self.diaryTask.filter{
            $0.diaryTitle.lowercased().contains(text) || $0.diaryContent.lowercased().contains(text)}
        collectionView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        collectionView.reloadData()
    }
}
