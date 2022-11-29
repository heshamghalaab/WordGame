//
//  WordsProvider.swift
//  WordGame
//
//  Created by Ghalaab on 26/11/2022.
//

import Foundation
import Combine

protocol WordsProvidable {
    var wordsPublisher: AnyPublisher<[Word], Never> { get }
}

struct WordsProvider: WordsProvidable {
    
    private let localDataProvider: LocalDataProvidable
    private let resource: String
    private let bundle: Bundle

    init(
        localDataProvider: LocalDataProvidable = LocalDataProvider(),
        resource: String = "words",
        bundle: Bundle = Bundle.main
    ) {
        self.localDataProvider = localDataProvider
        self.resource = resource
        self.bundle = bundle
    }
    
    var wordsPublisher: AnyPublisher<[Word], Never> {
        localDataProvider.data(in: bundle, forResource: resource)
            .decode(type: [Word].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
