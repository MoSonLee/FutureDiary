//
//  CurrentDiaryViewController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift
import SideMenu

final class CurrentDiaryViewController: UIViewController, UITextViewDelegate {
    
    let viewModel = CurrentDiaryViewModel()
    let currentTitleTextField = FuryTextField()
    let currentContentTextView = UITextView()
    
    private let saveButton = UIBarButtonItem()
    private let repository = RealmRepository()
    private let disposdeBag = DisposeBag()
    
    private var placeholderLabel : UILabel!
    private var deleteButton = UIBarButtonItem()
    
    private lazy var input = CurrentDiaryViewModel.Input(
        saveButtonTap: saveButton.rx.tap
            .withLatestFrom(
                Observable.combineLatest(
                    currentTitleTextField.rx.text.orEmpty,
                    currentContentTextView.rx.text.orEmpty
                ) {($0, $1)}
            )
            .asSignal(onErrorJustReturn: ("", ""))
    )
    
    private lazy var output = viewModel.transform(input: input)
    
    var diaryTask: Diary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
        setConstraints()
        setNavigation()
        bind()
        keybordFunction()
        setTextViewPlaceholder()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setTextViewPlaceholder() {
        currentContentTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "placeholderLabel_text".localized
        placeholderLabel.font = setCustomFont(size: 20)
        placeholderLabel.sizeToFit()
        currentContentTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 8, y: (currentContentTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !currentContentTextView.text.isEmpty
    }
    
    private func keybordFunction() {
        currentTitleTextField.becomeFirstResponder()
        self.hideKeyboardWhenTappedAround()
        currentContentTextView.delegate = self
        setUpTextFieldAndView()
    }
    
    private func setConfigure() {
        [currentTitleTextField, currentContentTextView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setViewComponents()
        setComponentsColor()
    }
    
    private func setViewComponents() {
        currentTitleTextField.placeholder = "title_placeholderLabel_text".localized
        currentTitleTextField.font = setCustomFont(size: 25)
        currentContentTextView.font = setCustomFont(size: 25)
    }
    
    private func setComponentsColor() {
        view.backgroundColor = UIColor(patternImage:  .backgroundImage)
        currentTitleTextField.textColor = CustomColor.shared.blackAndWhite
        currentContentTextView.backgroundColor = .clear
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            currentTitleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            currentTitleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            currentTitleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            currentTitleTextField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05),
            currentTitleTextField.bottomAnchor.constraint(equalTo: currentContentTextView.topAnchor, constant: -16),
            
            currentContentTextView.topAnchor.constraint(equalTo: currentTitleTextField.bottomAnchor, constant: 16),
            currentContentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            currentContentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            currentContentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    private func setNavigation() {
        self.navigationItem.title = "current_title".localized
        saveButton.title = "complete".localized
        deleteButton = UIBarButtonItem(image: .trash, style: .done, target: self, action: #selector(showDeleteAlert))
        deleteButton.tintColor = .systemRed
        if viewModel.diaryTask != nil {
            navigationItem.rightBarButtonItems = [saveButton, deleteButton]
        } else {
            navigationItem.rightBarButtonItem = saveButton
        }
        setNavigationColor()
    }
    
    @objc private func showDeleteAlert() {
        let alert =  UIAlertController(title: "deleteAlert_title".localized, message: "deleteAlert_message".localized, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel_title".localized, style: .cancel)
        guard let diary = self.viewModel.diaryTask else { return }
        
        let ok = UIAlertAction(title: "okAlert_title".localized, style:.destructive, handler: { _ in
            self.repository.delete(diary: diary)
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func adjustKeyboard(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let adjustmentHeight = keyboardFrame.height
        if noti.name == UIResponder.keyboardWillShowNotification {
            currentContentTextView.contentInset.bottom = adjustmentHeight - 60
        } else {
            currentContentTextView.contentInset.bottom = 0
        }
    }
    
    private func bind() {
        output.showAlert
            .emit(onNext: {[weak self] text, isSaved in
                let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "okAlert_title".localized, style: .destructive) { _ in
                    if isSaved {
                        self?.navigationController?.popViewController(animated: true)
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
    
    private func setUpTextFieldAndView() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "doneButton_title".localized, style: .done,
                                         target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        currentTitleTextField.inputAccessoryView = toolbar
        currentContentTextView.inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
}

extension CurrentDiaryViewController  {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
