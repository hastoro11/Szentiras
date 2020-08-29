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
            return "Hálózati hiba"
        default:
            return "Ismeretlen hiba"
        }
    }
}
