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
    var userDefaultsManager: UserDefaultManager
    
    @Published var translation: Translation {
        willSet {
            userDefaultsManager.setTranslationValue(newValue, forKey: .translation)
        }
    }
    
    @Published var allBooks: [CDBook] = []
    @Published var allVersesInABook: [CDVers] = []
    
    @Published var currentBook: CDBook? {
        willSet {
            userDefaultsManager.setIntValue(newValue!.number, forKey: .currentBook)
        }
    }
    @Published var currentChapter: Int {
        willSet {
            userDefaultsManager.setIntValue(newValue, forKey: .currentChapter)
        }
    }
    @Published var scrollToTarget: String?
    
    var saveFlag: Bool = true
    
    init(context: NSManagedObjectContext) {
        
        userDefaultsManager = UserDefaultManager()
        
        self.context = context
                
        translation = userDefaultsManager.translationValue(forKey: .translation)
        currentChapter = userDefaultsManager.intValue(forKey: .currentChapter)
        
        $translation
            .sink(receiveValue: fetchAllBooksFromDatabase(translation:))
            .store(in: &cancellables)
        $translation
            .sink { [self] _ in
                fetchVersesFromDatabaseFor(currentBook)
            }
            .store(in: &cancellables)
        $currentBook
            .sink(receiveValue: fetchVersesFromDatabaseFor)
            .store(in: &cancellables)
    }
    
    func fetchVersesFromDatabaseFor(_ book: CDBook?) {
        guard let book = book else {return}
        let request = CDVers.fetchRequest(predicate: NSPredicate(format: "translation_ = %@ and book_ = %@", book.translation.rawValue, book.abbrev))
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
                    if error == .server {
                        if translation == .KG {
                            translation = .RUF
                        }
                        
                    }
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
        if self.translation.changesFromCatholicToProtestant(to: translation) && self.currentBook!.isCatholic() {
            userDefaultsManager.setIntValue(108, forKey: .currentBook)
        }
        self.translation = translation
    }
    
    func fetchAllBooksFromDatabase(translation: Translation) {
        let request = CDBook.fetchRequest(predicate: NSPredicate(format: "translation_ = %@", translation.rawValue))
        let books = (try? context.fetch(request)) ?? []
        if books.isEmpty {
            fetchAllBooksFromNetwork(translation: translation)
        } else {            
            allBooks = books
            let currentBookNumber = userDefaultsManager.intValue(forKey: .currentBook)
            if let book = books.first(where: {$0.number == currentBookNumber}) {
                currentBook = book
            }            
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
