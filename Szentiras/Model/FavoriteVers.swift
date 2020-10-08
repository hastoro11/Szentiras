//
//  FavoriteVers.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 10. 03..
//

import Foundation

struct FavoriteVers: Codable, Identifiable, Comparable {
    
    static func < (lhs: FavoriteVers, rhs: FavoriteVers) -> Bool {
        lhs.order < rhs.order
    }
    

    var id: String { gepi }
    var gepi: String
    var szep: String
    var szoveg: String
    var translation: String
    var order: Int
    var timestamp: Date
}
