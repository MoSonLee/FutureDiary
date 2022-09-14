//
//  RealmRepository.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import Foundation

import RealmSwift

final class RealmRepository {
    
    private let realm = try! Realm()
    
    func create(diary: Diary, completion: ((Bool) -> Void)) {
        do {
            try realm.write {
                realm.add(diary)
            }
            completion(true)
            
        } catch let error {
            completion(false)
            print(error)
        }
    }
    
    func update(diary: Diary, completion: ((Bool) -> Void)) {
        do {
            try realm.write {
                realm.create(Diary.self, value: diary, update: .modified)
            }
            completion(true)
            
        } catch let error {
            completion(false)
            print(error)
        }
    }
    
    func fetch(date: Date) -> Results<Diary>! {
        return realm.objects(Diary.self)
            .filter("diaryDate <= %@", date)
            .sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    func fetch() -> Results<Diary>! {
        return realm.objects(Diary.self)
            .sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    func dateFilteredFetch(todayStartTime: Date, currentDate: Date) -> Results<Diary>! {
        return realm.objects(Diary.self)
            .filter("diaryDate BETWEEN {%@, %@}", todayStartTime, currentDate)
            .sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    func filterFuture(date: Date) -> Results<Diary> {
        return realm.objects(Diary.self)
            .filter("diaryDate > %@", date)
    }

    func delete(diary: Diary) {
        try! realm.write {
            realm.delete(diary)
        }
    }
    
    func delete(diary: Diary, completion: ((Bool) -> Void)) {
        do {
            try realm.write {
                realm.delete(diary)
            }
            completion(true)
            
        } catch let error {
            completion(false)
            print(error)
        }
    }
}
