//
//  FutureDiaryController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift
import SideMenu

final class FutureDiaryController: UIViewController {
    
    private let textViewPlaceHolder = "내용을 입력하세요"
    private let futureTitleTextField = FuryTextField()
    private let datePicker = UIDatePicker()
    private let saveButton = UIBarButtonItem()
    
    lazy var futureContentTextView = UITextView()
    
    private let viewModel = FutureDiaryViewModel()
    private let disposdeBag = DisposeBag()
    
    private lazy var input = FutureDiaryViewModel.Input(
        saveButtonTap: saveButton.rx.tap
            .withLatestFrom(
                Observable.combineLatest(
                    futureTitleTextField.rx.text.orEmpty,
                    futureContentTextView.rx.text.orEmpty,
                    datePicker.rx.date
                ) {($0, $1, $2)}
            )
            .asSignal(onErrorJustReturn: ("", "", Date()))
    )
    
    private lazy var output = viewModel.transform(input: input)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
        setConstraints()
        setNavigation()
        setDatePicker()
        bind()
    }
    
    private func setConfigure() {
        [futureTitleTextField, futureContentTextView, datePicker].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setViewComponents()
        setViewComponentsColor()
    }
    
    private func setViewComponents() {
        futureTitleTextField.placeholder = "제목을 입력해주세요"
        futureTitleTextField.layer.borderWidth = 1
        futureContentTextView.layer.borderWidth = 1
        datePicker.layer.borderWidth = 1
    }
    
    private func setViewComponentsColor() {
        view.backgroundColor = CustomColor.shared.backgroundColor
        futureTitleTextField.layer.borderColor = CustomColor.shared.textColor.withAlphaComponent(0.7).cgColor
        futureContentTextView.layer.borderColor = CustomColor.shared.textColor.withAlphaComponent(0.7).cgColor
        datePicker.layer.borderColor = CustomColor.shared.textColor.withAlphaComponent(0.7).cgColor
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            futureTitleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            futureTitleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            futureTitleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            futureTitleTextField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05),
            futureTitleTextField.bottomAnchor.constraint(equalTo: futureContentTextView.topAnchor, constant: -16),
            
            futureContentTextView.topAnchor.constraint(equalTo: futureTitleTextField.bottomAnchor, constant: 16),
            futureContentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            futureContentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            futureContentTextView.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -16),
            
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    private func setNavigation() {
        saveButton.title = "완료"
        self.navigationItem.title = "미래"
        navigationItem.rightBarButtonItem = saveButton
        UINavigationBar.appearance().isTranslucent = false
        setNavigationColor()
    }
    
    private func setNavigationColor() {
        self.navigationController?.navigationBar.tintColor = CustomColor.shared.buttonTintColor
        self.navigationItem.leftBarButtonItem?.tintColor = CustomColor.shared.buttonTintColor
        self.navigationItem.rightBarButtonItem?.tintColor = CustomColor.shared.buttonTintColor
    }
    
    private func setDatePicker() {
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        datePicker.locale = Locale(identifier: Locale.current.identifier)
        datePicker.timeZone = TimeZone(abbreviation: Locale.current.identifier)
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 2, to: datePicker.date)
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        datePicker.tintColor = CustomColor.shared.buttonTintColor
    }
    
    private func bind() {
        output.showAlert
            .emit(onNext: {[weak self] text, isSaved in
                let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .destructive) { _ in
                    if isSaved {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                }
                alert.addAction(confirmAction)
                self?.present(alert, animated: true)
            })
            .disposed(by: disposdeBag)
        
        output.showToast
            .emit(onNext: {[weak self] text in
                self?.view.makeToast(text)
            })
            .disposed(by: disposdeBag)
    }
    
    @objc private func handleDatePicker(_ sender: UIDatePicker) {
        print(datePicker.rx.date)
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
}
