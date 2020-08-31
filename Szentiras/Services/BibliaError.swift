//
//  BibliaError.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 28..
//

import Foundation

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
