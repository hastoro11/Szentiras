//
//  UserDefaultsManager.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 09. 18..
//

import Foundation

class UserDefaultManager {
    enum AppKey: String {
        case currentBook, currentChapter
    }
    
    init() {
        UserDefaults.standard.register(defaults: ["currentBook": 108, "currentChapter": 1])
    }
    
    func setValue(_ value: Int, forKey key: AppKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        
    }
    
    func value(forKey key: AppKey) -> Int {
        UserDefaults.standard.integer(forKey: key.rawValue)
    }
}
