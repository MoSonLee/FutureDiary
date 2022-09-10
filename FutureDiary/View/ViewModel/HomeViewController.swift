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
    
    private let viewModel = HomeViewModel()
    private let repository = RealmRepository()
    private let localRealm = try! Realm()
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let writeDiaryButton = UIButton()
    private let calendarView = UIView()
    private let datePicker = UIDatePicker()
    private let dateLabel = UILabel()
    private var isChecked: Bool = false
    
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
        writeDiaryButton.addTarget(self, action: #selector(writeButtonTap), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
    }
    
    private func fetchRealm() {
        diaryTask = repository.dateFilteredFetch(todayStartTime: datePicker.date.startOfDay, currentDate: datePicker.date)
        collectionView.reloadData()
    }
    
    private func setConfigure() {
        [collectionView, writeDiaryButton, calendarView, dateLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        dateLabel.textAlignment = .center
        setComponentsColor()
        setComponentsTextAndImage()
    }
    
    private func setComponentsColor() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        writeDiaryButton.tintColor = .black
        calendarView.layer.borderColor = UIColor.black.cgColor
        calendarView.layer.borderWidth = 1
    }
    
    private func setComponentsTextAndImage() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 44, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "pencil.circle.fill", withConfiguration: largeConfig)
        writeDiaryButton.setImage(largeBoldDoc, for: .normal)
        dateLabel.text = setDateFormatToString(date: datePicker.date)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dateLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            calendarView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 1),
            
            collectionView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            writeDiaryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:  -16),
            writeDiaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func collectionViewRegisterAndDelegate() {
        collectionView.register(HomeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: HomeCollectionViewCell.identifider)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = setCollectionViewLayout()
    }
    
    private func setNavigation() {
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.circle"), style: .done, target: self, action: #selector(setSideMenu))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar.circle"), style: .done, target: self, action: #selector(showCalendar))
        self.navigationController?.navigationBar.topItem?.title = "FURY"
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    private func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        let width = UIScreen.main.bounds.width / 3 - spacing
        layout.itemSize = CGSize(width: width, height: width * 1.4)
        return layout
    }
    
    private func setDateFormatToString(date: Date) -> String {
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy.MM.dd"
        myDateFormatter.locale = Locale(identifier:"ko_KR")
        myDateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return myDateFormatter.string(from: datePicker.date)
    }
    
    private func setCalendar() {
        calendarView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(method), for: .valueChanged)
        datePicker.tintColor = .black
    }
    
    @objc func writeButtonTap() {
        let alert = UIAlertController(title: "작성하실 일기 종류를 선택해주세요", message: nil, preferredStyle: .actionSheet)
        
        let current = UIAlertAction(title: "오늘", style: .default , handler: { _ in
            let vc = CurrentDiaryViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let future = UIAlertAction(title: "미래", style: .default , handler: { _ in
            let vc = FutureDiaryController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let cancel = UIAlertAction(title: "취소", style: .destructive , handler: { _ in
            self.dismiss(animated: true)
        })
        [current, future].forEach {
            alert.addAction($0)
            $0.setValue(UIColor.black, forKey: "titleTextColor")
        }
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    @objc func showCalendar() {
        
        if !isChecked {
            setCalendar()
            isChecked = !isChecked
            calendarView.setHeight(view.bounds.height * 0.5)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.up.circle"), style: .done, target: self, action: #selector(showCalendar))
        }
        else {
            isChecked = !isChecked
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar.circle"), style: .done, target: self, action: #selector(showCalendar))
            datePicker.removeFromSuperview()
            calendarView.setHeight(1)
        }
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        dateLabel.text = setDateFormatToString(date: picker.date)
        fetchRealm()
    }
    
    @objc private func setSideMenu() {
        let menu = SideMenuNavigationController(rootViewController: SideMenuViewController())
        menu.leftSide = true
        menu.blurEffectStyle = .dark
        menu.presentationStyle = .viewSlideOutMenuIn
        present(menu, animated: true, completion: nil)
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
