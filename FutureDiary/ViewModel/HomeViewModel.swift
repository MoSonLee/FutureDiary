//
//  HomeViewModel.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/10/21.
//

import Foundation

import RealmSwift

class HomeViewModel {
     let repository = RealmRepository()
     var diarys: Results<Diary>!
     var futureDiary: Results<Diary>!
    
    func getDiaryCount() -> Int {
        diarys.count
    }
}
