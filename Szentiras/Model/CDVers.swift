//
//  CDVers.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 09. 16..
//

import SwiftUI
import CoreData

extension CDVers {
    var book: String {
        get { book_ ?? ""}
        set { book_ = newValue }
    }
    var chapter: Int {
        get { Int(chapter_) }
        set { chapter_ = Int16(newValue) }
    }
    var gepi: String {
        get { gepi_ ?? ""}
        set { gepi_ = newValue }
    }
    var index: Int {
        get { Int(index_) }
        set { index_ = Int16(newValue) }
    }
    var szep: String {
        get { szep_ ?? ""}
        set { szep_ = newValue }
    }
    var szoveg: String {
        get { szoveg_ ?? ""}
        set { szoveg_ = newValue }
    }
    var translation: String {
        get { translation_ ?? ""}
        set { translation_ = newValue }
    }
    var notes: String {
        get { notes_ ?? ""}
        set { notes_ = newValue }
    }
    var marking: Color {
        get { return marking_ == nil ? Color.clear : Color(marking_!) }
    }
}

extension CDVers {
    static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<CDVers> {
        let request = NSFetchRequest<CDVers>(entityName: "CDVers")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDVers.gepi_, ascending: true)]
        request.predicate = predicate
        
        return request
    }
    
    static func saveVersesFromResults(book: CDBook, results: [Result], context: NSManagedObjectContext) {
        if checkIfBookHasBeenSaved(book: book, context: context) { return }
        results.forEach({result in
            saveVersesFromOneResult(book: book, result: result, context: context)
        })
    }
    
    private static func checkIfBookHasBeenSaved(book: CDBook, context: NSManagedObjectContext) -> Bool {
        let predicate = NSPredicate(format: "book_ = %@ and translation_ = %@", argumentArray: [book.abbrev, book.translation.rawValue])
        let request = CDVers.fetchRequest(predicate: predicate)
        let verses = (try? context.fetch(request)) ?? []
        return !verses.isEmpty
    }
    
    private static func saveVersesFromOneResult(book: CDBook, result: Result, context: NSManagedObjectContext) {
        result.valasz.versek.forEach { vers in

            guard let chapter = result.chapter else { return }
            let cdVers = CDVers(context: context)
            cdVers.book = book.abbrev
            cdVers.chapter = chapter
            cdVers.gepi = vers.gepi
            cdVers.index = Int(vers.szep.split(separator: ",")[1]) ?? 0
            cdVers.szep = vers.szep
            cdVers.szoveg = vers.szoveg ?? ""
            cdVers.translation = book.translation.rawValue
            
            try? context.save()
        }
    }
    
    static func deleteMarking(color: String, vers: FavoriteVers, context: NSManagedObjectContext) {
        let predicate = NSPredicate(format: "marking_ = %@ and gepi_ = %@ and translation_ = %@", color, vers.gepi, vers.translation)
        let request = fetchRequest(predicate: predicate)
        let verses = (try? context.fetch(request)) ?? []
        _ = verses.map({$0.marking_ = nil})
        try? context.save()
    }
}

extension CDVers {
    func saveNotes(notes: String, context: NSManagedObjectContext) {
        self.notes = notes
        self.timestamp = Date()
        try? context.save()
    }
    
    func deleteNotes(context: NSManagedObjectContext) {
        self.notes_ = nil
        self.timestamp = nil
        try? context.save()
    }
    
    func setMarking(color: String, context: NSManagedObjectContext) {
        if marking_ == color {
            self.marking_ = nil
        } else {
            self.marking_ = color
        }        
        try? context.save()
        self.objectWillChange.send()
    }
}
