//
//  ObservableViewModelTests.swift
//  WordGameTests
//
//  Created by Ghalaab on 28/11/2022.
//

import XCTest
import Combine
import CombineSchedulers

@testable import WordGame

final class ObservableViewModelTests: XCTestCase {

    struct ViewState: Equatable {
        let isLoading: Bool

        static let idle = ViewState(isLoading: false)
        static let loading = ViewState(isLoading: true)
    }

    enum Action {
        case loadingDidChange(Bool)
    }

    var viewStateSubject: PassthroughSubject<ViewState, Never>!
    var adapter: ViewModelAdapter<ViewState, Action>!
    var sut: ObservableViewModel<ViewState, Action>!
    var testScheduler: TestSchedulerOf<DispatchQueue>!

    override func setUpWithError() throws {
        let initialState = ViewState.loading

        testScheduler = DispatchQueue.test
        viewStateSubject = PassthroughSubject()
        adapter = ViewModelAdapter(
            initialState: initialState,
            query: viewStateSubject.eraseToAnyPublisher(),
            send: { action in
            switch action {
            case .loadingDidChange(let isLoading):
                self.viewStateSubject.send(isLoading ? .loading : .idle)
            }
        })

        sut = ObservableViewModel(
            viewModelAdapter: adapter,
            scheduler: testScheduler.eraseToAnyScheduler())
    }

    func testPublishedViewState() {
        let observer = sut.$viewState.test()

        viewStateSubject.send(.idle)
        testScheduler.advance()

        observer.assertValues([.loading, .idle])
    }
}
