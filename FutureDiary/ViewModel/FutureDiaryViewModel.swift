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
                    self?.showAlertRelay.accept(("제목을 필수로 입력해주세요", false))
                } else {
                    guard let dateString = self?.setDateFormatToString(date: diary.2) else { return }
                    let diaryModel =  Diary(diaryTitle: diary.0, diaryContent: diary.1, diaryDate: diary.2, diaryDateToString: dateString)
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
                self.showAlertRelay.accept(("미래로 일기를 보내드렸습니다", true))
            } else {
                self.showToastRelay.accept("오류가 발생했습니다. 다시 시도해주세요")
            }
        }
    }
}
