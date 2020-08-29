//
//  BibliaStore.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import Foundation
import Combine

class BibliaStore: ObservableObject {
    @Published var biblia: Biblia
    @Published var currentBook: Book
    @Published var results: [Result] = []
    @Published var isLoading = false
    @Published var error: BibliaError?
    @Published var currentChapter: Int = 1
    
    var bookCancellable: Cancellable?
    var cancellables = Set<AnyCancellable>()
    var network = NetworkLayer()
    
    func changeTranslation(to translation: Translation) {
        biblia.translation = translation
    }
    
    func fetchBook() {
        fetchBook(biblia: biblia)
    }
    
    private func fetchBook(biblia: Biblia) {
        isLoading = true
        bookCancellable?.cancel()
        
        bookCancellable = network.fetchBookResults(biblia: biblia, book: currentBook)
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
    
    init(biblia: Biblia) {
        self.biblia = biblia
        self.currentBook = biblia.books[40]
        $currentBook
            .sink(receiveValue: { [unowned self]_ in
                fetchBook()
            })
            .store(in: &cancellables)
    }
}
