//
//  LocalDataProviderTests.swift
//  WordGameTests
//
//  Created by Ghalaab on 28/11/2022.
//

import XCTest
import Combine

@testable import WordGame

final class LocalDataProviderTests: XCTestCase {

    var sut: LocalDataProvidable!
    private var cancellables = Set<AnyCancellable>()
    
    func testDataWhenJsonFileHasData() {
        var words: [Word] = []
        sut.data(in: Bundle(for: LocalDataProviderTests.self), forResource: "wordsMock")
            .decode(type: [Word].self, decoder: JSONDecoder())
            .sink { _ in } receiveValue: { words = $0 }
            .store(in: &cancellables)
        XCTAssertFalse(words.isEmpty)
    }
    
    func testDataWhenJsonFileIsEmpty() {
        var words: [Word] = []
        sut.data(in: Bundle(for: LocalDataProviderTests.self), forResource: "wordsMockEmpty")
            .decode(type: [Word].self, decoder: JSONDecoder())
            .sink { _ in } receiveValue: { words = $0 }
            .store(in: &cancellables)
        XCTAssertTrue(words.isEmpty)
    }
    
    override func setUpWithError() throws {
        sut = LocalDataProvider()
    }
}
