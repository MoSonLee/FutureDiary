//
//  DiaryRepository.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import Foundation

import RealmSwift

class DiaryRepository {
    
    let localRealm = try! Realm()
    
    func fetch(today: Date) -> Results<Diary>! {
        //여기서 sorted 앞에 필터
        return localRealm.objects(Diary.self).sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    func deleteItem(item: Diary) {
        try! localRealm.write {
            localRealm.delete(item)
        }
    }
    
    func updateMemo(item: Diary, title: String, content: String, date: Date) {
        item.diaryTitle = title
        item.diaryContent = content
        item.diaryDate = Date()
    }
}
