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
    
    func update(diary: Diary, completion: ((Bool) -> Void)) {
        do {
            try localRealm.write {
                localRealm.create(Diary.self, value: diary, update: .modified)
            }
            completion(true)
            
        } catch let error {
            completion(false)
            print(error)
        }
    }
    
    func fetch(date: Date) -> Results<Diary>! {
        return localRealm.objects(Diary.self)
            .filter("diaryDate <= %@", date)
            .sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    func fetch() -> Results<Diary>! {
        return localRealm.objects(Diary.self)
            .sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    func dateFilteredFetch(todayStartTime: Date, currentDate: Date) -> Results<Diary>! {
        return localRealm.objects(Diary.self)
            .filter("diaryDate BETWEEN {%@, %@}", todayStartTime, currentDate)
            .sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    func delete(item: Diary) {
        try! localRealm.write {
            localRealm.delete(item)
        }
    }
}
