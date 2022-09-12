//
//  RealmRepository.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import Foundation

import RealmSwift

final class RealmRepository {
    
    private let localRealm = try! Realm()
    
    func create(diary: Diary, completion: ((Bool) -> Void)) {
        do {
            try localRealm.write {
                localRealm.add(diary)
            }
            completion(true)
            
        } catch let error {
            completion(false)
            print(error)
        }
    }
    
    func fetch(today: Date) -> Results<Diary>! {
        return localRealm.objects(Diary.self).sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    func dateFilteredFetch(todayStartTime: Date, currentDate: Date) -> Results<Diary>! {
        return localRealm.objects(Diary.self)
            .filter("diaryDate >= %@ && diaryDate <= %@", todayStartTime, currentDate.addingTimeInterval(60))
            .sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    func delete(item: Diary) {
        try! localRealm.write {
            localRealm.delete(item)
        }
    }
    
    func update(item: Diary, title: String, content: String, date: Date) {
        item.diaryTitle = title
        item.diaryContent = content
        item.diaryDate = Date()
    }
}
