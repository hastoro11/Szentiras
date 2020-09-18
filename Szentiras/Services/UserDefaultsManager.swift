//
//  UserDefaultsManager.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 09. 18..
//

import Foundation

class UserDefaultManager {
    enum AppKey: String {
        case currentBook, currentChapter, translation
    }
    
    init() {
        UserDefaults.standard.register(defaults: ["currentBook": 108, "currentChapter": 1, "translation": "RUF"])
    }
    
    func setIntValue(_ value: Int, forKey key: AppKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func intValue(forKey key: AppKey) -> Int {
        UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    func translationValue(forKey key: AppKey) -> Translation {
        let str = UserDefaults.standard.string(forKey: key.rawValue) ?? "RUF"
        return Translation(rawValue: str)!
    }
    
    func setTranslationValue(_ value: Translation, forKey key: AppKey) {
        UserDefaults.standard.set(value.rawValue, forKey: key.rawValue)
    }
}
