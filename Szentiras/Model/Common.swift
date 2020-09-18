//
//  Common.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 09. 15..
//

import Foundation

enum Translation: String, CaseIterable {
    case RUF, KG, KNB, SZIT
    
    var name: String {
        switch self {
        case .RUF:
            return "Magyar Bibliatársulat újfordítású Bibliája (2014)"
        case .KG:
            return "Károli Gáspár revideált fordítása"
        case .KNB:
            return "Káldi-Neovulgáta"
        case .SZIT:
            return "Szent István Társulati Biblia"
        }
    }
    
    var shortName: String{
        switch self {
        case .RUF:
            return "Újfordítású Biblia"
        case .KG:
            return "Károli fordítás"
        case .KNB:
            return "Káldi-Neovulgáta"
        case .SZIT:
            return "Szent István Társulat"
        }
    }
    
    func changesFromCatholicToProtestant(to translation: Translation) -> Bool {
        return (self == .KNB || self == .SZIT ) && (translation == .KG || translation == .RUF)        
    }
}

enum BibliaError: Error, CustomStringConvertible, Identifiable {
    var id: String {
        self.description
    }
    
    case network, parsing, unknown
    
    var description: String {
        switch self {
        case .network:
            return "Hálózati hiba, talán a készülék nem csatlakozik az internethez."
        case .parsing:
            return "Fordítási hiba, ha lehetőség van rá, értesítse a program készítőjét."
        default:
            return "Ismeretlen hiba lépett fel. Ha lehetőség van rá, értesítse a program készítőjét."
        }
    }
}
