//
//  LocalDataProvider.swift
//  WordGame
//
//  Created by Ghalaab on 26/11/2022.
//

import Foundation
import Combine

enum FetchingDataError: Error {
    case cannotReadData
}

protocol LocalDataProvidable {
    func data(in bundle: Bundle, forResource resource: String) -> AnyPublisher<Data, Error>
}

struct LocalDataProvider: LocalDataProvidable {
    func data(in bundle: Bundle, forResource resource: String) -> AnyPublisher<Data, Error> {
        bundle.path(forResource: resource, ofType: "json")
            .publisher
            .tryMap { path -> Data in
                guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
                    throw FetchingDataError.cannotReadData
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}
