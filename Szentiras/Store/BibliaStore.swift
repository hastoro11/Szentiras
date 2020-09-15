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
    @Published var booksResult: BooksResult?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        translation = .RUF
        $translation
            .sink(receiveValue: fetchAllBooksFromNetwork(translation:))
            .store(in: &cancellables)
            
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
            }, receiveValue: { self.booksResult = $0 })
            .store(in: &cancellables)
    }
}
