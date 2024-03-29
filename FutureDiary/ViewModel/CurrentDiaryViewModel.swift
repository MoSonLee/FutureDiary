//
//  CurrentDiaryViewModel.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import Foundation

import RxCocoa
import RxSwift

final class CurrentDiaryViewModel {
    
    struct Input {
        let saveButtonTap: Signal<(String,String)>
    }
    
    struct Output {
        let showAlert: Signal<(String, Bool)>
        let showToast: Signal<String>
        let dismiss: Signal<Void>
    }
    
    var diaryTask: Diary?
    
    private let respository = RealmRepository()
    private let showAlertRelay = PublishRelay<(String, Bool)>()
    private let showToastRelay = PublishRelay<String>()
    private let popVCRelay = PublishRelay<Void>()
    private let disoiseBag = DisposeBag()
    
    private func setDateFormatToString(date: Date) -> String {
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy.MM.dd"
        myDateFormatter.locale = Locale(identifier: Locale.current.identifier)
        myDateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        return myDateFormatter.string(from: date)
    }
    
    func transform(input: Input) -> Output {
        input.saveButtonTap
            .emit(onNext: { [weak self] diary in
                if diary.0.count == 0 {
                    self?.showAlertRelay.accept(("title_placeholderLabel_text".localized, false))
                } else if let diaryTask = self?.diaryTask {
                    self?.updateRealm(diary: diaryTask, title: diary.0, content: diary.1)
                } else {
                    let diaryModel =  Diary(diaryTitle: diary.0, diaryContent: diary.1, diaryDate: Date())
                    self?.saveRealm(diary: diaryModel)
                }
            })
            .disposed(by: disoiseBag)
        
        return Output(
            showAlert: showAlertRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            dismiss: popVCRelay.asSignal())
    }
}

extension CurrentDiaryViewModel {
    private func saveRealm(diary: Diary) {
        respository.create(diary: diary) { isSaved in
            if isSaved {
                self.showAlertRelay.accept(("mail_store".localized, true))
            } else {
                self.showToastRelay.accept("error_occured_try_again".localized)
            }
        }
    }
    
    private func updateRealm(diary: Diary, title: String, content: String) {
        respository.update(diary: diary, title: title, content: content) { isSaved in
            if isSaved {
                self.showAlertRelay.accept(("mail_store".localized, true))
            } else {
                self.showToastRelay.accept("error_occured_try_again".localized)
            }
        }
    }
}
