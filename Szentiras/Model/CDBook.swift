//
//  CDBook.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 09. 15..
//

import Foundation
import CoreData

extension CDBook {
    var abbrev: String {
        get { abbrev_ ?? ""}
        set { abbrev_ = newValue }
    }
    var name: String {
        get { name_ ?? ""}
        set { name_ = newValue }
    }
    var translation: Translation {
        get { Translation(rawValue: translation_ ?? "RUF") ?? .RUF }
        set { translation_ = newValue.rawValue }
    }
    var number: Int {
        get { Int(number_) }
        set { number_ = Int16(newValue) }
    }
}

extension CDBook {
    static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<CDBook> {
        let request = NSFetchRequest<CDBook>(entityName: "CDBook")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDBook.number_, ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func saveBooksResult(booksResult: BooksResult, context: NSManagedObjectContext) {
        booksResult.books.forEach({book in
            let cdBook = CDBook(context: context)
            cdBook.abbrev = book.abbrev
            cdBook.name = book.name
            cdBook.number = book.number
            cdBook.translation = Translation(rawValue: booksResult.translationStruct.abbrev) ?? .RUF
            try? context.save()
        })
    }
    
    func isCatholic() -> Bool {
        return self.number == 117 || self.number == 118 || self.number == 125 || self.number == 126 || self.number == 130 || self.number == 145 || self.number == 146
    }
}
