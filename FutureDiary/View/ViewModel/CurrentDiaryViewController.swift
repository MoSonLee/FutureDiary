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
import Toast

final class CurrentDiaryViewController: UIViewController {
    
    private let textViewPlaceHolder = "내용을 입력하세요"
    private let saveButton = UIBarButtonItem()
    var deleteButton = UIBarButtonItem()
    private let repository = RealmRepository()
    
    let currentTitleTextField = FuryTextField()
    
    lazy var currentContentTextView = UITextView()
    
    let viewModel = CurrentDiaryViewModel()
    private let disposdeBag = DisposeBag()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
        setConstraints()
        setNavigation()
        bind()
        
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
        currentTitleTextField.placeholder = "제목을 입력해주세요"
        currentTitleTextField.layer.borderWidth = 1
        currentContentTextView.layer.borderWidth = 1
        currentContentTextView.font = .systemFont(ofSize: 16)
        
    }
    
    private func setComponentsColor() {
        view.backgroundColor = CustomColor.shared.backgroundColor
        currentTitleTextField.layer.borderColor = CustomColor.shared.textColor.withAlphaComponent(0.7).cgColor
        currentContentTextView.layer.borderColor = CustomColor.shared.textColor.withAlphaComponent(0.7).cgColor
        currentTitleTextField.textColor = CustomColor.shared.textColor
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
        saveButton.title = "완료"
        self.navigationItem.title = "현재"
        deleteButton = UIBarButtonItem(title: "삭제", style: .done, target: self, action: #selector(showDeleteAlert))
        if viewModel.diaryTask != nil {
            navigationItem.rightBarButtonItems = [saveButton, deleteButton]
        } else {
            navigationItem.rightBarButtonItem = saveButton
        }
        UINavigationBar.appearance().isTranslucent = false
        setNavigationColor()
    }
    
    private func setNavigationColor() {
        UINavigationBar.appearance().barTintColor = CustomColor.shared.buttonTintColor
        UINavigationBar.appearance().tintColor = CustomColor.shared.buttonTintColor
        self.navigationController?.navigationBar.tintColor = CustomColor.shared.buttonTintColor
        self.navigationItem.rightBarButtonItem?.tintColor = CustomColor.shared.buttonTintColor
    }
    
    //rx로 수정예정
    @objc func showDeleteAlert() {
        let alert =  UIAlertController(title: "정말 삭제하실건가요?", message: "삭제하시면 복구할 수 없어요!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        guard let diary = self.viewModel.diaryTask else { return }
        
        let ok = UIAlertAction(title: "확인", style:.destructive, handler: { _ in
            self.repository.delete(diary: diary)
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
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
}
