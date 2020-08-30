//
//  ActionSheet+Extension.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 30..
//

import SwiftUI

extension ActionSheet {
    static func translationActionSheet(store: BibliaStore) -> ActionSheet {
        let translations = Translation.allCases
        return ActionSheet(
            title: Text("Válassz fordítást"),
            message: Text(""),
            buttons: [
                .default(Text(translations[0].shortName), action: {store.changeTranslation(to: translations[0])}),
                .default(Text(translations[1].shortName), action: {store.changeTranslation(to: translations[1])}),
                .default(Text(translations[2].shortName), action: {store.changeTranslation(to: translations[2])}),
                .default(Text(translations[3].shortName), action: {store.changeTranslation(to: translations[3])}),
                .cancel(Text("Mégsem"))
            ])
    }
    
}

