//
//  FutureDiaryController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit

import IQKeyboardManagerSwift
import RealmSwift
import RxCocoa
import RxSwift
import SideMenu

final class FutureDiaryController: UIViewController, UITextViewDelegate {
    
    private let futureTitleTextField = FuryTextField()
    private let datePicker = UIDatePicker()
    private let saveButton = UIBarButtonItem()
    private var placeholderLabel : UILabel!
    private let futureContentTextView = UITextView()
    
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
    private var keybord = IQKeyboardManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
        setConstraints()
        setNavigation()
        setDatePicker()
        bind()
        keybordFunction()
        setTextViewPlaceholder()
    }
    
    private func setTextViewPlaceholder() {
        futureContentTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "내용을 입력하세요"
        placeholderLabel.font = .italicSystemFont(ofSize: (futureContentTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        futureContentTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 8, y: (futureContentTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !futureContentTextView.text.isEmpty
    }
    
    private func keybordFunction() {
        futureTitleTextField.becomeFirstResponder()
        self.hideKeyboardWhenTappedAround()
        futureContentTextView.delegate = self
        setUpTextFieldAndView()
        keybord.enable = true
        keybord.enableAutoToolbar = false
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
        futureContentTextView.font = .systemFont(ofSize: 16)
        datePicker.layer.borderWidth = 1
    }
    
    private func setViewComponentsColor() {
        view.backgroundColor = CustomColor.shared.backgroundColor
        datePicker.layer.borderColor = CustomColor.shared.textColor.withAlphaComponent(0.3).cgColor
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
        datePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 1, to: datePicker.date)
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
    
    private func setUpTextFieldAndView() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                         target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        futureTitleTextField.inputAccessoryView = toolbar
        futureContentTextView.inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
}

extension FutureDiaryController  {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
