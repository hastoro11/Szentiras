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
    
}

