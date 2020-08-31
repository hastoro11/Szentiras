//
//  NetworkLayer.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import Foundation
import Combine

class NetworkLayer: ObservableObject {
    
    func fetchBookResults(biblia: Biblia, book: Book) -> AnyPublisher<[Result], BibliaError> {
        let publishers = (1...book.chapters).map({ ch -> AnyPublisher<Result, BibliaError> in
            fetchChapterResult(biblia: biblia, book: book, chapter: ch)
        })
        
        return Publishers.MergeMany(publishers).collect().eraseToAnyPublisher()
    }
    
    private func fetchChapterResult(biblia: Biblia, book: Book, chapter: Int) -> AnyPublisher<Result, BibliaError> {
        let url = URL(string: "https://szentiras.hu/api/idezet/\(book.abbreviation.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)\(chapter)/\(biblia.translation.rawValue)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .tryMap { data, response -> Data in
                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    throw BibliaError.network
                }
                if data.isEmpty {
                    throw BibliaError.network
                }
                return data
            }
            .decode(type: Result.self, decoder: JSONDecoder())
            .mapError({error -> BibliaError in
                switch error {
                case is URLError:
                    return BibliaError.network
                case is DecodingError:
                    return BibliaError.parsing
                default:
                    return error as? BibliaError ?? .unknown
                }
            })
            .eraseToAnyPublisher()
    }
    
}

