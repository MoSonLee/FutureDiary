//
//  Diary.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import Foundation

import RealmSwift

final class Diary: Object {
    
    @Persisted var diaryTitle: String
    @Persisted var diaryContent: String
    @Persisted var diaryDate: Date
    @Persisted var diaryDateToString: String
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(diaryTitle: String, diaryContent: String, diaryDate: Date, diaryDateToString: String) {
        self.init()
        self.diaryTitle = diaryTitle
        self.diaryContent = diaryContent
        self.diaryDate = diaryDate
        self.diaryDateToString = diaryDateToString
    }
}
