//
//  ViewModelAdapterTests.swift
//  WordGameTests
//
//  Created by Ghalaab on 28/11/2022.
//

import Foundation
import XCTest
import Combine
@testable import WordGame

class ViewModelAdapterTests: XCTestCase {
    struct AppState: Equatable {
        let name: String
        let isLoading: Bool

        static var initialState: AppState {
            AppState(name: "Initial State", isLoading: true)
        }
    }

    enum AppAction {
        case foo
    }

    enum ScreenViewState {
        case idle, loading
    }

    var viewStateSubject: CurrentValueSubject<AppState, Never>!
    var sut: ViewModelAdapter<AppState, Never>!
    
    override func setUpWithError() throws {
        viewStateSubject = CurrentValueSubject(AppState.initialState)
        
        sut = ViewModelAdapter(
            initialState: AppState.initialState,
            query: viewStateSubject.eraseToAnyPublisher(),
            send: neverAction)
    }

    func testActionSentIsDelivered() {
        var actionRegistered: AppAction?
        let sut = ViewModelAdapter<Void, AppAction>(
            initialState: (),
            query: Empty(completeImmediately: false).eraseToAnyPublisher(),
            send: { action in
                actionRegistered = action
            }
        )

        sut.send(.foo)

        XCTAssertEqual(actionRegistered, .foo)
    }

    func testMultipleSubscribers() {
        let testScheduler = DispatchQueue.test
        let stream1 = PassthroughSubject<Int, Never>()
        let stream2 = PassthroughSubject<Int, Never>()
        let query = Publishers.CombineLatest(stream1.prepend(1), stream2).map(+).eraseToAnyPublisher()

        let sut = ViewModelAdapter<Int, Never>(initialState: 0, query: query, send: neverAction)
        let observableViewModel1 = ObservableViewModel(viewModelAdapter: sut, scheduler: testScheduler.eraseToAnyScheduler())

        stream2.send(2)
        testScheduler.advance()

        XCTAssertEqual(observableViewModel1.viewState, 3)

        let observableViewModel2 = ObservableViewModel(viewModelAdapter: sut, scheduler: testScheduler.eraseToAnyScheduler())

        stream1.send(3)
        testScheduler.advance()

        XCTAssertEqual(observableViewModel1.viewState, 5)
        XCTAssertEqual(observableViewModel2.viewState, 5)

        let observableViewModel3 = ObservableViewModel(viewModelAdapter: sut, scheduler: testScheduler.eraseToAnyScheduler())

        stream2.send(4)
        testScheduler.advance()

        XCTAssertEqual(observableViewModel1.viewState, 7)
        XCTAssertEqual(observableViewModel2.viewState, 7)
        XCTAssertEqual(observableViewModel3.viewState, 7)
    }
}
