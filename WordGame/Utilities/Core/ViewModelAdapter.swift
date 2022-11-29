//
//  ViewModelAdapter.swift
//  WordGame
//
//  Created by Ghalaab on 27/11/2022.
//

import Foundation
import Combine

struct ViewModelAdapter<State, Action> {
    var state: State { stateSubject.value }
    let query: AnyPublisher<State, Never>
    let send: (Action) -> Void
    
    private let stateSubject: CurrentValueSubject<State, Never>
    private var cancellables = Set<AnyCancellable>()
    
    init(
        initialState: State,
        query: AnyPublisher<State, Never> = Empty<State, Never>().eraseToAnyPublisher(),
        send: @escaping (Action) -> Void
    ) {
        self.query = query
            .share()
            .eraseToAnyPublisher()
        self.send = send
        self.stateSubject = CurrentValueSubject<State, Never>(initialState)
        query
            .assign(to: \.value, on: stateSubject)
            .store(in: &cancellables)
    }
}

func neverAction<A>(_: Never) -> A { /* Never */ }
