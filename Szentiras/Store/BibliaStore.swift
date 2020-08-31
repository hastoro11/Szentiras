//
//  BibliaStore.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import Foundation
import SwiftUI
import Combine

class BibliaStore: ObservableObject {
    @Published var biblia: Biblia
    @Published var currentBook: Book {
        didSet {
            saveUserDefaults()
        }
    }
    @Published var results: [Result] = []
    @Published var isLoading = false
    @Published var error: BibliaError?
    @Published var currentChapter: Int {
        didSet {
            saveUserDefaults()
        }
    }
    
    var bookCancellable: Cancellable?
    var cancellables = Set<AnyCancellable>()
    var network = NetworkLayer()
    
    func changeTranslation(to translation: Translation) {
        if (biblia.translation == .KNB || biblia.translation == .SZIT) && (translation == .KG || translation == .RUF) {
            biblia.translation = translation
            currentBook = biblia.books[0]
        } else {
            biblia.translation = translation
        }
        currentChapter = min(currentChapter, currentBook.chapters)
        saveUserDefaults()
    }
    
    func changeTranslationWhileReading(to translation: Translation) {
        biblia.translation = translation
        currentChapter = min(currentChapter, currentBook.chapters)
        fetchBook(book: currentBook)
        saveUserDefaults()
    }
    
    private func saveUserDefaults() {
        UserDefaults.standard.set(biblia.translation.rawValue, forKey: "translation")
        let currentBookIndex = biblia.books.firstIndex(of: currentBook) ?? 0
        UserDefaults.standard.set(currentChapter, forKey: "currentChapter")
        UserDefaults.standard.set(currentBookIndex, forKey: "currentBookIndex")
    }
    
    func fetchBook(book: Book) {
        isLoading = true
        bookCancellable?.cancel()
        
        bookCancellable = network.fetchBookResults(biblia: biblia, book: book)
            .sink(receiveCompletion: { [unowned self] in
                isLoading = false
                switch $0 {
                case .failure(let error):
                    self.error = error
                default:
                    break
                }
            }, receiveValue: {results in
                self.results = results.sorted(by: {lh, rh -> Bool in
                    let lv = Int(lh.keres.hivatkozas.split(separator: " ")[1]) ?? 0
                    let rv = Int(rh.keres.hivatkozas.split(separator: " ")[1]) ?? 0
                    return lv < rv
                })
                
            })
    }
    
    init(translation: Translation) {
        let biblia = Biblia(with: translation)
        self.biblia = biblia
        let currentBookIndex = UserDefaults.standard.integer(forKey: "currentBookIndex")
        self.currentBook = biblia.books[currentBookIndex]
        self.currentChapter = max(UserDefaults.standard.integer(forKey: "currentChapter"), 1)
        $currentBook
            .sink(receiveValue: { [unowned self] book in
                fetchBook(book: book)
            })
            .store(in: &cancellables)
    }
    
}
