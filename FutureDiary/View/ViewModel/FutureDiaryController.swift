//
//  FutureDiaryController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit

final class FutureDiaryController: UIViewController {
    
    private let textViewPlaceHolder = "내용을 입력하세요"
    private let futureTitleTextField = FuryTextField()
    private let datePicker = UIDatePicker()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
        setConstraints()
        setNavigation()
        setDatePicker()
    }
    
    private func setConfigure() {
        view.backgroundColor = .systemGray
        [futureTitleTextField, futureContentTextView, datePicker].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        futureTitleTextField.placeholder = "제목을 입력해주세요"
        futureTitleTextField.layer.borderWidth = 1
        futureTitleTextField.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        futureContentTextView.backgroundColor = .systemGray
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(method))
        self.navigationItem.title = "미래"
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        self.navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func setDatePicker() {
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
    
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        datePicker.tintColor = .systemIndigo
    }
    
    @objc private func handleDatePicker(_ sender: UIDatePicker) {
        print(sender.date)
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
