//
//  WordsProviderMock.swift
//  WordGameTests
//
//  Created by Ghalaab on 29/11/2022.
//

import Foundation
import Combine

@testable import WordGame

struct WordsProviderMock: WordsProvidable {
    
    var words: [Word]

    init(words: [Word] = Word.wordsMock) {
        self.words = words
    }
    
    var wordsPublisher: AnyPublisher<[Word], Never> {
        Just(words).eraseToAnyPublisher()
    }
}
