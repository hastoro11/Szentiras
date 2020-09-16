//
//  NetworkLayer.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import Foundation
import Combine

class NetworkLayer: ObservableObject {
    
    static func fetchAllBooksFromNetwork(translation: Translation) -> AnyPublisher<BooksResult, BibliaError> {
        let urlStr = "https://szentiras.hu/api/books/\(translation.rawValue)"
        let url = URL(string: urlStr)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({data, response in
                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    throw BibliaError.network
                }
                if data.isEmpty {
                    throw BibliaError.network
                }
                
                return data
            })
            .decode(type: BooksResult.self, decoder: JSONDecoder())
            .mapError({error -> BibliaError in
                switch error {
                case is URLError:
                    return .network
                case is DecodingError:
                    return .parsing
                default:
                    return error as? BibliaError ?? .unknown
                }
            })
            .eraseToAnyPublisher()
    }
    
    static func fetchVersesFromNetwork(for book: CDBook) -> AnyPublisher<[Result], BibliaError> {
        guard let chaptersInBook = bookChapters[book.number] else { return Empty(outputType: [Result].self, failureType: BibliaError.self).eraseToAnyPublisher() }
        let publishers = (1...chaptersInBook).map({fetchChapterFromNetwork(for: book, chapter: $0)})
        
        return Publishers.MergeMany(publishers).collect().eraseToAnyPublisher()
    }
    
    private static func fetchChapterFromNetwork(for book: CDBook, chapter: Int) -> AnyPublisher<Result, BibliaError> {
        let urlStr = "https://szentiras.hu/api/idezet/\(book.abbrev.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)\(chapter)/\(book.translation)"
        let url = URL(string: urlStr)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({data, response in
                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    throw BibliaError.network
                }
                if data.isEmpty {
                    throw BibliaError.network
                }
                
                return data
            })
            .decode(type: Result.self, decoder: JSONDecoder())
            .mapError({error -> BibliaError in
                switch error {
                case is URLError:
                    return .network
                case is DecodingError:
                    return .parsing
                default:
                    return error as? BibliaError ?? .unknown
                }
            })
            .eraseToAnyPublisher()
//        return Empty(outputType: Result.self, failureType: BibliaError.self).eraseToAnyPublisher()
    }
    
}

