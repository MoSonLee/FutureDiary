//
//  CurrentDiaryViewController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit

import RealmSwift
import Toast

final class CurrentDiaryViewController: UIViewController {
    
    private let textViewPlaceHolder = "내용을 입력하세요"
    private let appearance = UINavigationBarAppearance()
    
    private let currentTitleTextField = UITextField()
    
    lazy var currentContentTextView: UITextView = {
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
    
    private let localRealm = try! Realm()
    private let respository = DiaryRepository()
    var diaryTasks: Diary?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
        setConstraints()
        setNavigation()
    }
    
    private func setConfigure() {
        view.backgroundColor = .systemGray
        [currentTitleTextField, currentContentTextView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        currentTitleTextField.placeholder = "    제목을 입력해주세요"
        currentTitleTextField.layer.borderWidth = 1
        currentTitleTextField.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        currentContentTextView.backgroundColor = .systemGray
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
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemIndigo
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(addCurrentDiary))
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "현재"
        self.navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc private func addCurrentDiary() {
        guard let titleText = currentTitleTextField.text else { return }
        
        do {
            try localRealm.write {
                let task = Diary(diaryTitle: titleText, diaryContent: currentContentTextView.text, diaryDate: Date())
                localRealm.add(task)
            }
            
        } catch let error {
            view.makeToast("오류가 발생했습니다. 다시 시도해주세요")
            print(error)
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension CurrentDiaryViewController: UITextViewDelegate {
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
