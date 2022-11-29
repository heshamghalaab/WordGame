//
//  LocalDataProviderMock.swift
//  WordGameTests
//
//  Created by Ghalaab on 29/11/2022.
//

import Foundation
import Combine

@testable import WordGame

struct LocalDataProviderMock: LocalDataProvidable {
    
    var words: [Word]
    
    init(words: [Word] = Word.wordsMock) {
        self.words = words
    }
    
    func data(in bundle: Bundle, forResource resource: String) -> AnyPublisher<Data, Error> {
        let data = (try? JSONEncoder().encode(words)) ?? Data()
        return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
