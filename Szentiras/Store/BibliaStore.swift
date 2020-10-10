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
    
    @Published var booksLoaded: Bool = false
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

    @Published var favouritesDictionary: [String: [FavoriteVers]] = [
        "Red": [],
        "Yellow": [],
        "Green": [],
        "Blue": []
    ]
    
    // MARK: - Init
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
        
        // Favourites
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(url.path)
        url.appendPathComponent("Favourites")
        url.appendPathExtension("json")
        
        if !FileManager.default.fileExists(atPath: url.path) {
            saveFavourites()
        } else {
            loadFavourites()
        }
    }
    
    // MARK: - Favourites functions
    private func saveFavourites() {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        url.appendPathComponent("Favourites")
        url.appendPathExtension("json")
                
        let encoder = JSONEncoder()
        let data = try! encoder.encode(favouritesDictionary)

        try? data.write(to: url)
    }
    
    private func loadFavourites() {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        url.appendPathComponent("Favourites")
        url.appendPathExtension("json")
        
        let decoder = JSONDecoder()
        let data = try! Data(contentsOf: url)
        favouritesDictionary = (try? decoder.decode([String: [FavoriteVers]].self, from: data)) ?? [:]
    }
    
    func addFavourite(vers: CDVers) {
        let favouriteVers = FavoriteVers(gepi: vers.gepi, szep: vers.szep, szoveg: vers.szoveg, translation: vers.translation, order: 0, timestamp: Date())
        filterSavedFavourites(vers: favouriteVers)
        
        if vers.marking_ != nil {
            favouritesDictionary[vers.marking_!]?.append(favouriteVers)
            reorder(color: vers.marking_!)
        }
        saveFavourites()        
    }
    
    private func filterSavedFavourites(vers: FavoriteVers) {
        for key in favouritesDictionary.keys {
            favouritesDictionary[key] = favouritesDictionary[key]?.filter({$0.gepi != vers.gepi || $0.translation != vers.translation})
        }
    }
    
    func moveFavourites(color: String, indexSet: IndexSet, newOffset: Int) {
        if favouritesDictionary[color] != nil {
            favouritesDictionary[color]!.move(fromOffsets: indexSet, toOffset: newOffset)
            reorder(color: color)
        }
        saveFavourites()
    }
    
    func deleteFavourite(vers: CDVers) {
        guard let color = vers.marking_, let favs = favouritesDictionary[color], let index = favs.firstIndex(where: {$0.gepi == vers.gepi && $0.translation == vers.translation}) else { return }
        favouritesDictionary[color]!.remove(at: index)
        reorder(color: color)
        saveFavourites()
    }
    
    func deleteFavourite(color: String, vers: FavoriteVers) {
        guard let dict = favouritesDictionary[color] else {
            print("no dict")
            return
        }
        guard let favIndex = dict.firstIndex(of: vers) else {
            print("no index")
            return
        }
        favouritesDictionary[color]!.remove(at: favIndex)
        CDVers.deleteMarking(color: color, vers: vers, context: context)
        reorder(color: color)
        saveFavourites()
    }
    
    func deleteFavourites(color: String, indexSet: IndexSet) {
        if favouritesDictionary[color] != nil {
            for i in indexSet {
                CDVers.deleteMarking(color: color, vers: favouritesDictionary[color]![i], context: context)
            }            
            favouritesDictionary[color]!.remove(atOffsets: indexSet)
            reorder(color: color)
            
        }
        
        saveFavourites()
    }
    
    private func reorder(color: String) {
        var favs = [FavoriteVers]()
        for (i, v) in favouritesDictionary[color]!.enumerated() {
            var f = v
            f.order = i
            favs.append(f)
        }
        favouritesDictionary[color]! = favs
    }
    
    func jumpToVers(vers: FavoriteVers) {
        guard let translation = Translation(rawValue: vers.translation) else {
            print("no translation")
            return
        }
        self.changeTranslation(to: translation)
        let bookAbbrev = String(vers.szep.split(separator: " ")[0])
        let request = CDBook.fetchRequest(predicate: NSPredicate(format: "abbrev_ = %@", bookAbbrev))
        guard let book = try? context.fetch(request)[0] else {
            print("no book")
            return
        }
        self.currentBook = book
        guard let chapter = Int(vers.szep.split(separator: " ")[1].split(separator: ",")[0]) else {
            print("no chapter")
            return
        }
        self.currentChapter = chapter
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scrollToTarget = vers.gepi
        }
        
    }
    
    // MARK: - Translation change
    func changeTranslation(to translation: Translation) {
        if self.translation.changesFromCatholicToProtestant(to: translation) && self.currentBook!.isCatholic() {
            userDefaultsManager.setIntValue(108, forKey: .currentBook)
        }
        self.translation = translation
    }
    
    //MARK: - Fetching functions
    // Fetching verses
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
    
    // Fetching books
    func fetchAllBooksFromDatabase(translation: Translation) {
        let request = CDBook.fetchRequest(predicate: NSPredicate(format: "translation_ = %@", translation.rawValue))
        let books = (try? context.fetch(request)) ?? []
        if books.isEmpty {
            fetchAllBooksFromNetwork(translation: translation)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) { [self] in
                booksLoaded = true
            }            
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
