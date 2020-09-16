//
//  BibliaStore.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import Foundation
import SwiftUI
import Combine
import CoreData

class BibliaStore: ObservableObject {
    var context: NSManagedObjectContext
    @Published var isLoading: Bool = false
    @Published var error: BibliaError?
    var cancellables = Set<AnyCancellable>()
    
    @Published var translation: Translation    
    @Published var allBooks: [CDBook] = []
    @Published var allVersesInABook: [CDVers] = []
    
    @Published var currentBook: CDBook?
    @Published var currentChapter: Int
    
    init(context: NSManagedObjectContext) {
        self.context = context
        translation = .RUF
        currentChapter = 1
        $translation
            .sink(receiveValue: fetchAllBooksFromDatabase(translation:))
            .store(in: &cancellables)
        $currentBook
            .sink(receiveValue: fetchVersesFromDatabaseFor)
            .store(in: &cancellables)
    }
    
    func fetchVersesFromDatabaseFor(_ book: CDBook?) {
        guard let book = book else {return}
        let request = CDVers.fetchRequest(predicate: NSPredicate(format: "translation_ = %@ and book_ = %@", translation.rawValue, book.abbrev))
        let verses = (try? context.fetch(request)) ?? []
        if verses.isEmpty {
            fetchVersesFromNetwork(for: book)
        } else {
            allVersesInABook = verses
        }
    }
    
    func fetchVersesFromNetwork(for book: CDBook) {
        isLoading = true
        NetworkLayer.fetchVersesFromNetwork(for: book)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [self]completion in
                isLoading = false
                switch completion {
                case .failure(let error):
                    self.error = error
                default:
                    break
                }
            }, receiveValue: { [self]results in
                CDVers.saveVersesFromResults(book: book, results: results, context: context)
                fetchVersesFromDatabaseFor(book)
            })
            .store(in: &cancellables)
    }
    
    func changeTranslation(to translation: Translation) {
        self.translation = translation
    }
    
    func fetchAllBooksFromDatabase(translation: Translation) {
        let request = CDBook.fetchRequest(predicate: NSPredicate(format: "translation_ = %@", translation.rawValue))
        let books = (try? context.fetch(request)) ?? []
        if books.isEmpty {
            fetchAllBooksFromNetwork(translation: translation)
        } else {
            self.allBooks = books
            self.currentBook = books[7]
        }
    }
    
    func fetchAllBooksFromNetwork(translation: Translation) {
        isLoading = true
        NetworkLayer.fetchAllBooksFromNetwork(translation: translation)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [unowned self]completion in
                isLoading = false
                switch completion {
                case .failure(let error):
                    self.error = error
                default:
                    break
                }
            }, receiveValue: { [self] in
                CDBook.saveBooksResult(booksResult:$0, context: context)
                fetchAllBooksFromDatabase(translation: translation)
            })
            .store(in: &cancellables)
    }
    
}
