//
//  ActionSheet+Extension.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 30..
//

import SwiftUI

extension ActionSheet {
    static func translationActionSheet(store: BibliaStore, book: Book, readingView: Bool) -> ActionSheet {
//        let translations = Translation.allCases
        func buttons() -> [ActionSheet.Button] {
//            if readingView {
//                if book.isCatholicBook() {
//                    return [
//                        ActionSheet.Button.default(Text(translations[2].shortName), action: {store.changeTranslationWhileReading(to: translations[2])}),
//                        ActionSheet.Button.default(Text(translations[3].shortName), action: {store.changeTranslationWhileReading(to: translations[3])}),
//                        ActionSheet.Button.cancel(Text("Mégsem"))
//                    ]
//                } else {
//                    return [
//                        ActionSheet.Button.default(Text(translations[0].shortName), action: {store.changeTranslationWhileReading(to: translations[0])}),
//                        ActionSheet.Button.default(Text(translations[1].shortName), action: {store.changeTranslationWhileReading(to: translations[1])}),
//                        ActionSheet.Button.default(Text(translations[2].shortName), action: {store.changeTranslationWhileReading(to: translations[2])}),
//                        ActionSheet.Button.default(Text(translations[3].shortName), action: {store.changeTranslationWhileReading(to: translations[3])}),
//                        ActionSheet.Button.cancel(Text("Mégsem"))
//                    ]
//                }
//            } else {
                return [
//                    ActionSheet.Button.default(Text(translations[0].shortName), action: {store.changeTranslation(to: translations[0])}),
//                    ActionSheet.Button.default(Text(translations[1].shortName), action: {store.changeTranslation(to: translations[1])}),
//                    ActionSheet.Button.default(Text(translations[2].shortName), action: {store.changeTranslation(to: translations[2])}),
//                    ActionSheet.Button.default(Text(translations[3].shortName), action: {store.changeTranslation(to: translations[3])}),
                    ActionSheet.Button.cancel(Text("Mégsem"))
                ]
//            }
        }
        
        return ActionSheet(
            title: Text("Válassz fordítást"),
            message: Text(""),
            buttons: buttons())
    }
    
}

