//
//  FutureDiaryController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit

import RealmSwift
import Toast
import RxSwift
import RxCocoa
import RxRelay

final class FutureDiaryController: UIViewController {
    
    private let textViewPlaceHolder = "내용을 입력하세요"
    private let futureTitleTextField = FuryTextField()
    private let datePicker = UIDatePicker()
    private let saveButton = UIBarButtonItem()
    
    
    lazy var futureContentTextView: UITextView = {
        let view = UITextView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        view.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        view.font = .systemFont(ofSize: 18)
        view.text = textViewPlaceHolder
        view.textColor = .lightGray
        view.delegate = self
        return view
    }()
    
    private let viewModel = FutureDiaryViewModel()
    private let disposdeBag = DisposeBag()
    
    private lazy var input = FutureDiaryViewModel.Input(
        saveButtonTap: saveButton.rx.tap
            .withLatestFrom(
                Observable.combineLatest(
                    futureTitleTextField.rx.text.orEmpty,
                    futureContentTextView.rx.text.orEmpty,
                    datePicker.rx.date.changed
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
        view.backgroundColor = .white
        futureContentTextView.layer.borderColor = UIColor.black.withAlphaComponent(0.7).cgColor
        datePicker.layer.borderColor = UIColor.black.withAlphaComponent(0.7).cgColor
        futureContentTextView.backgroundColor = .white
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
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    private func setDatePicker() {
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        datePicker.tintColor = .black
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

extension FutureDiaryController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}
