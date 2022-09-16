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
import Toast

final class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private let repository = RealmRepository()
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let writeDiaryButton = UIButton()
    private let calendarView = UIView()
    private let datePicker = UIDatePicker()
    private let dateLabel = UILabel()
    private var isChecked: Bool = false
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private var diarys: Results<Diary>! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var futureDiary: Results<Diary>!
    private var futureDiaryTime: [Date] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.applicationIconBadgeNumber = 0
        fetchRealm()
        requestAuthorization()
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
    
    private func requestAuthorization() {
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        notificationCenter.requestAuthorization(options: authorizationOptions) { success, error in
            if success {
                self.sendNotification()
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let application = UIApplication.shared
        
        if(application.applicationState == .active){
            print("user tapped the notification bar when the app is in foreground")
        }
        
        if(application.applicationState == .inactive)
        {
            print("user tapped the notification bar when the app is in background")
        }
        completionHandler()
    }
    
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "일기가 도착했습니다!"
        notificationContent.body = "과거로부터 온 편지를 확인해보세요"
        notificationContent.sound = .default
        notificationContent.badge = 1
        
        futureDiaryTime = futureDiaryTime.filter{ $0 > Date()}
        futureDiaryTime.forEach {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: $0.timeIntervalSince(Date()), repeats: false)
            let request = UNNotificationRequest(identifier: "\($0)" , content: notificationContent , trigger: trigger)
            notificationCenter.add(request)
        }
    }
    
    private func fetchRealm() {
        if datePicker.date < Date().toStartOfDay {
            diarys = repository.dateFilteredFetch(todayStartTime: datePicker.date.toStartOfDay, currentDate: datePicker.date.toEndOfDay)
        } else {
            diarys = repository.dateFilteredFetch(todayStartTime: datePicker.date.toStartOfDay, currentDate: Date())
        }
        
        futureDiary = repository.filterFuture(date: Date())
        futureDiary.forEach {
            futureDiaryTime.append($0.diaryDate)
        }
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
        view.backgroundColor = CustomColor.shared.backgroundColor
        collectionView.backgroundColor = CustomColor.shared.backgroundColor
        writeDiaryButton.tintColor = CustomColor.shared.buttonTintColor
        calendarView.layer.borderColor = CustomColor.shared.textColor.cgColor
        calendarView.layer.borderWidth = 1
    }
    
    private func setComponentsTextAndImage() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 44, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "pencil.circle.fill", withConfiguration: largeConfig)
        writeDiaryButton.setImage(largeBoldDoc, for: .normal)
        dateLabel.text = datePicker.date.toString
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dateLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            calendarView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:  8),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
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
        self.navigationItem.leftBarButtonItem?.tintColor = CustomColor.shared.buttonTintColor
        self.navigationItem.rightBarButtonItem?.tintColor = CustomColor.shared.buttonTintColor
    }
    
    private func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let width = (UIScreen.main.bounds.width / 3 - spacing * 2)
            layout.itemSize = CGSize(width: width, height: width * 0.7)
            return layout
        } else {
            let width = UIScreen.main.bounds.width - spacing
            layout.itemSize = CGSize(width: width, height: width * 0.5)
            return layout
        }
    }
    
    private func setCalendar() {
        calendarView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.tintColor = CustomColor.shared.buttonTintColor
        datePicker.locale = Locale(identifier: Locale.autoupdatingCurrent.identifier)
        datePicker.timeZone = TimeZone(abbreviation: Locale.autoupdatingCurrent.identifier)
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(method), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: calendarView.safeAreaLayoutGuide.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: calendarView.safeAreaLayoutGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: calendarView.safeAreaLayoutGuide.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: calendarView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func moveToEditDiary(indexPath: IndexPath) {
        let vc = CurrentDiaryViewController()
        vc.currentTitleTextField.text = diarys[indexPath.row].diaryTitle
        vc.currentContentTextView.text = diarys[indexPath.row].diaryContent
        vc.viewModel.diaryTask = diarys[indexPath.row]
        print(diarys[indexPath.row].objectId)
        self.navigationController?.pushViewController(vc, animated: true)
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
        [current, future, cancel].forEach {
            alert.addAction($0)
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            self.present(alert, animated: true) }
    }
    
    @objc func showCalendar() {
        if !isChecked {
            setCalendar()
            isChecked = !isChecked
            calendarView.setHeight(view.bounds.height * 0.5, animateTime: 0.5)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.up.circle"), style: .done, target: self, action: #selector(showCalendar))
        } else {
            isChecked = !isChecked
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar.circle"), style: .done, target: self, action: #selector(showCalendar))
            datePicker.removeFromSuperview()
            calendarView.setHeight(1, animateTime: 0.5)
        }
        self.navigationItem.rightBarButtonItem?.tintColor = CustomColor.shared.buttonTintColor
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        dateLabel.text = picker.date.toString
        fetchRealm()
    }
    
    @objc private func setSideMenu() {
        let menu = SideMenuNavigationController(rootViewController: SideMenuViewController())
        menu.leftSide = true
        menu.isNavigationBarHidden = true
        menu.blurEffectStyle = .systemMaterial
        menu.presentationStyle = .viewSlideOut
        present(menu, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        diarys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveToEditDiary(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifider, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell()}
        cell.diaryTitleTextLabel.text = diarys[indexPath.row].diaryTitle
        cell.diaryTextView.text = diarys[indexPath.row].diaryContent
        cell.diaryDateLabel.text = diarys[indexPath.row].diaryDate.toDetailString
        cell.diaryDateLabel.textAlignment = .center
        cell.diaryDateLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
}
