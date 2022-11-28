//
//  WordsProviderTests.swift
//  WordGameTests
//
//  Created by Ghalaab on 29/11/2022.
//

import XCTest
import Combine

@testable import WordGame

final class WordsProviderTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    
    func testWordsWhenDataExists() {
        let sut = WordsProvider(localDataProvider: LocalDataProviderMock())
        var words: [Word] = []
        sut.wordsPublisher
            .sink {
                words = $0
            }
            .store(in: &cancellables)
        XCTAssertFalse(words.isEmpty)
    }
    
    func testWordsWhenDataDoNotExists() {
        let sut = WordsProvider(localDataProvider: LocalDataProviderMock(words: []))
        var words: [Word] = []
        sut.wordsPublisher
            .sink { words = $0 }
            .store(in: &cancellables)
        XCTAssertTrue(words.isEmpty)
    }
    
}
