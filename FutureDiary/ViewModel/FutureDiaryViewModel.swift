//
//  FutureDiaryViewModel.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import Foundation

import RxCocoa
import RxSwift

final class FutureDiaryViewModel {
    
    struct Input {
        let saveButtonTap: Signal<(String,String, Date)>
    }
    
    struct Output {
        let showAlert: Signal<(String, Bool)>
        let showToast: Signal<String>
        let dismiss: Signal<Void>
    }
    
    private let showAlertRelay = PublishRelay<(String, Bool)>()
    private let showToastRelay = PublishRelay<String>()
    private let popVCRelay = PublishRelay<Void>()
    private let respository = RealmRepository()
    private let disoiseBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.saveButtonTap
            .emit(onNext: { [weak self] diary in
                if diary.0.count == 0 {
                    self?.showAlertRelay.accept(("title_placeholderLabel_text".localized, false))
                } else if diary.2 <= Date() {
                    self?.showToastRelay.accept("미래 시간으로 선택해주세요!")
                }
                else {
                    let diaryModel =  Diary(diaryTitle: diary.0, diaryContent: diary.1, diaryDate: diary.2)
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

extension FutureDiaryViewModel {
    private func saveRealm(diary: Diary) {
        respository.create(diary: diary) { isSaved in
            if isSaved {
                self.showAlertRelay.accept(("send_to_future".localized, true))
            } else {
                self.showToastRelay.accept("error_occured_try_again".localized)
            }
        }
    }
}
