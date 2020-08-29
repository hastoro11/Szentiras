//
//  String+Extension.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 24..
//

import Foundation

extension String {
    var strippedHTMLElements: String {
        var s = self
        if s.range(of: #"<\w+>"#, options: .regularExpression) != nil {
            s = s.replacingOccurrences(of: #"<\w+>"#, with: "", options: .regularExpression)
        }
        return s
    }
}
