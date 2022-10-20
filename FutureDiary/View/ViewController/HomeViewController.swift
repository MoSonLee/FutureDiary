//
//  HomeViewController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit

import SideMenu

final class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let writeDiaryButton = UIButton()
    private let calendarView = UIView()
    private let datePicker = UIDatePicker()
    private let dateLabel = UILabel()
    private var isChecked: Bool = false
    private let notificationCenter = UNUserNotificationCenter.current()
    
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
        sendNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: NSNotification.Name(rawValue: "reloadCollectionView"), object: nil)
        moveToWriteReview()
    }
    
    @objc func reloadCollectionView() {
        fetchRealm()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver("reloadCollectionView")
    }
    
    private func requestAuthorization() {
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        notificationCenter.requestAuthorization(options: authorizationOptions) { success, error in
            if success {
                self.sendNotification()
            }
        }
    }
    
    private func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "notification_title".localized
        notificationContent.body = "notification_body".localized
        notificationContent.sound = .default
        notificationContent.badge = 1
        
        futureDiaryTime = futureDiaryTime.filter{ $0 > Date()}
        futureDiaryTime.forEach {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: $0.timeIntervalSince(Date()), repeats: false)
            let request = UNNotificationRequest(identifier: "\($0)" , content: notificationContent , trigger: trigger)
            notificationCenter.add(request)
        }
    }
    
    func fetchRealm() {
        if datePicker.date < Date().toStartOfDay {
            viewModel.diarys = viewModel.repository.dateFilteredFetch(todayStartTime: datePicker.date.toStartOfDay, currentDate: datePicker.date.toEndOfDay)
        } else {
            viewModel.diarys = viewModel.repository.dateFilteredFetch(todayStartTime: datePicker.date.toStartOfDay, currentDate: Date())
        }
        viewModel.futureDiary = viewModel.repository.filterFuture(date: Date())
        viewModel.futureDiary.forEach {
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
        dateLabel.font = setCustomFont(size: 25)
        setComponentsColor()
        setComponentsTextAndImage()
    }
    
    private func setComponentsColor() {
        view.backgroundColor = UIColor(patternImage: .backgroundImage)
        collectionView.backgroundColor = .clear
        writeDiaryButton.tintColor = CustomColor.shared.blackAndWhite
        writeDiaryButton.backgroundColor = CustomColor.shared.whiteAndBlack
        writeDiaryButton.layer.cornerRadius = 22
    }
    
    private func setComponentsTextAndImage() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "pencil", withConfiguration: largeConfig)
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
            calendarView.heightAnchor.constraint(equalToConstant: 0),
            
            collectionView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            writeDiaryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:  -16),
            writeDiaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            writeDiaryButton.widthAnchor.constraint(equalToConstant: 44),
            writeDiaryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func collectionViewRegisterAndDelegate() {
        collectionView.register(HomeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: HomeCollectionViewCell.identifider)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = setHomeCollectionViewLayout()
    }
    
    private func setNavigation() {
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem(image: .lineweight, style: .done, target: self, action: #selector(setSideMenu))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .calendar, style: .done, target: self, action: #selector(showCalendar))
        self.navigationController?.navigationBar.topItem?.title = "Home_navigation_title".localized
        setNavigationColor()
    }
    
    private func setCalendar() {
        calendarView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: Locale.autoupdatingCurrent.identifier)
        datePicker.timeZone = TimeZone(abbreviation: Locale.autoupdatingCurrent.identifier)
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(method), for: .valueChanged)
        datePicker.tintColor = CustomColor.shared.blackAndGray
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: calendarView.safeAreaLayoutGuide.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: calendarView.safeAreaLayoutGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: calendarView.safeAreaLayoutGuide.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: calendarView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func moveToEditDiary(indexPath: IndexPath) {
        let vc = CurrentDiaryViewController()
        vc.currentTitleTextField.text = viewModel.diarys[indexPath.row].diaryTitle
        vc.currentContentTextView.text = viewModel.diarys[indexPath.row].diaryContent
        vc.viewModel.diaryTask = viewModel.diarys[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func moveToWriteReview() {
        if let appstoreUrl = URL(string: "https://apps.apple.com/app/id{6443563805}") {
            var urlComp = URLComponents(url: appstoreUrl, resolvingAgainstBaseURL: false)
            urlComp?.queryItems = [
                URLQueryItem(name: "action", value: "write-review")
            ]
            guard let reviewUrl = urlComp?.url else {
                return
            }
            UIApplication.shared.open(reviewUrl, options: [:], completionHandler: nil)
        }
    }
    
    @objc func writeButtonTap() {
        let alert = UIAlertController(title: "writebutton_alertTitle".localized, message: nil, preferredStyle: .actionSheet)
        let current = UIAlertAction(title: "current_title".localized, style: .default , handler: { _ in
            let vc = CurrentDiaryViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let future = UIAlertAction(title: "future_title".localized, style: .default , handler: { _ in
            let vc = FutureDiaryController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let cancel = UIAlertAction(title: "cancel_title".localized, style: .cancel , handler: { _ in
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
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .chervonUp, style: .done, target: self, action: #selector(showCalendar))
        } else {
            isChecked = !isChecked
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .calendar, style: .done, target: self, action: #selector(showCalendar))
            calendarView.setHeight(0, animateTime: 0.5)
            datePicker.removeFromSuperview()
        }
        self.navigationItem.rightBarButtonItem?.tintColor = CustomColor.shared.blackAndWhite
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        dateLabel.text = picker.date.toString
        fetchRealm()
    }
    
    @objc private func setSideMenu() {
        let menu = SideMenuNavigationController(rootViewController: SideMenuViewController())
        menu.leftSide = true
        menu.isNavigationBarHidden = true
        menu.presentationStyle = .viewSlideOutMenuIn
        menu.presentationStyle.backgroundColor = CustomColor.shared.sideMenuColor
        present(menu, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getDiaryCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveToEditDiary(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifider, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell()}
        cell.configureHomeCollectionViewCell(diarys: viewModel.diarys, indexPath: indexPath)
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) {  _ in
            self.collectionView.collectionViewLayout = self.setHomeCollectionViewLayout()
        }
    }
}
