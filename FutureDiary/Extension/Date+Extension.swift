//
//  Date+Extension.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/15.
//

import Foundation

extension Date {
    
    var toStartOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var toEndOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: toStartOfDay)!
    }
    
    var toShortString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        formatter.dateFormat = "a hh:mm"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: self)
    }
    
    var toString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: self)
    }
    
    var toDetailString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        formatter.dateFormat = "yyyy.MM.dd a hh:mm"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: self)
    }
}
