//
//  Date+Extension.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 09. 26..
//

import Foundation

extension Date {
    var stringFormat: String {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: now)        
        if let year = components.year, year > 0 {
            return "\(year) évvel ezelőtt"
        }
        if let month = components.month, month > 0 {
            return "\(month) hónappal ezelőtt"
        }
        
        if let day = components.day, day > 0 {
            return "\(day) nappal ezelőtt"
        }
        
        if let hour = components.hour, hour > 0 {
            return "\(hour) órával ezelőtt"
        }
        
        if let minute = components.minute, minute > 0 {
            return "\(minute) perccel ezelőtt"
        }
        
        if let second = components.second, second > 0 {
            return "\(second) másodperccel ezelőtt"
        }
        
        return "Másodpercekkel ezelőtt"
    }
}
