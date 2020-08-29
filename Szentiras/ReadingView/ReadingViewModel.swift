//
//  ReadingViewModel.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import Foundation
import SwiftUI

class ReadingViewModel: ObservableObject {
    @Published var fontSize = 1.0
    @Published var showIndex = true
    @Published var continous = false
    
    var textSize: Font {
        switch fontSize {
        case 0.0:
            return Font.light16
        case 1.0:
            return Font.light18
        case 2.0:
            return Font.light20
        default:
            return Font.light22
        }
    }
    
    var indexSize: Font {
        switch fontSize {
        case 0.0:
            return Font.medium16
        case 1.0:
            return Font.medium18
        case 2.0:
            return Font.medium20
        default:
            return Font.medium22
        }
    }
    
}
