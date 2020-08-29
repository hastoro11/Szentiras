//
//  BibliaStore.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import Foundation
import Combine

class BibliaStore: ObservableObject {
    @Published var biblia = Biblia(with: .RUF)
    
    func changeTranslation(to translation: Translation) {
        biblia.translation = translation
    }
}
