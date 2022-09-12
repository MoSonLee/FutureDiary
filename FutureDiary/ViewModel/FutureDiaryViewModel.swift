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
        myDateFormatter.dateFormat = "yyyy.MM.dd.hh.mm"
        myDateFormatter.locale = Locale(identifier:"ko_KR")
        myDateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return myDateFormatter.string(from: date)
    }
    
    func transform(input: Input) -> Output {
        input.saveButtonTap
            .emit(onNext: { [weak self] diary in
                if diary.0.count == 0 {
                    self?.showAlertRelay.accept(("제목을 필수로 입력해주세요", false))
                } else {
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
                self.showAlertRelay.accept(("미래로 일기를 보내드렸습니다", true))
            } else {
                self.showToastRelay.accept("오류가 발생했습니다. 다시 시도해주세요")
            }
        }
    }
}
