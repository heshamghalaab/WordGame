//
//  CombineTestObserver.swift
//  WordGameTests
//
//  Created by Ghalaab on 28/11/2022.
//

import Foundation
import Combine
import XCTest

extension Publisher {
    func test() -> CombineTestObserver<Output, Failure> {
        CombineTestObserver<Output, Failure>(publisher: eraseToAnyPublisher())
    }
}

final class CombineTestObserver<V, E: Error> {
    var values: [V] = []
    var error: E?
    var completed = false
    private var cancellable: AnyCancellable?

    init(publisher: AnyPublisher<V, E>) {
        cancellable = publisher.sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                self?.onCompleted()
            case.failure(let error):
                self?.onError(error: error)
            }
        }, receiveValue: { [weak self] value in
            self?.onValue(value: value)
        })
    }

    private func onValue(value: V) {
        values += [value]
    }

    private func onError(error: E) {
        self.error = error
    }

    private func onCompleted() {
        completed = true
    }

    func assertCount(_ expectedCount: Int) {
        XCTAssertEqual(self.values.count, expectedCount)
    }
    
    func assertComplete() {
        XCTAssertTrue(self.completed)
    }
}

extension CombineTestObserver where V: Equatable {
    func assertValues(_ expectedValues: [V]) {
        XCTAssertEqual(self.values, expectedValues)
    }

    func assertFirstValue(_ expectedValue: V){
        XCTAssertEqual(self.values.first, expectedValue)
    }

    func assertLastValue(_ expectedValue: V) {
        XCTAssertEqual(self.values.last, expectedValue)
    }
    
    func assertNil() {
        XCTAssertNil(self.values.last)
    }
}

