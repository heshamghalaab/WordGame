//
//  ObservableViewModel.swift
//  WordGame
//
//  Created by Ghalaab on 27/11/2022.
//

import Foundation
import Combine
import CombineSchedulers
import SwiftUI

final class ObservableViewModel<ViewState, Action>: ObservableObject {
    @Published var viewState: ViewState
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModelAdapter: ViewModelAdapter<ViewState, Action>
    
    init(
        viewModelAdapter: ViewModelAdapter<ViewState, Action>,
        schedular: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
    ) {
        self.viewModelAdapter = viewModelAdapter
        self.viewState = viewModelAdapter.state
        viewModelAdapter.query
            .receive(on: schedular)
            .assignNoRetain(to: \.viewState, on: self)
            .store(in: &cancellables)
    }
    
    func send(_ action: Action) {
        viewModelAdapter.send(action)
    }
}

struct WithObservableViewModel<ViewState, Action, Content> {
    private let content: (ObservableViewModel<ViewState, Action>) -> Content
    
    @ObservedObject private var observableViewModel: ObservableViewModel<ViewState, Action>
    
    init(
        _ viewModelAdapter: ViewModelAdapter<ViewState, Action>,
        @ViewBuilder content: @escaping (ObservableViewModel<ViewState, Action>) -> Content
    ) {
        self.content = content
        self.observableViewModel = ObservableViewModel(viewModelAdapter: viewModelAdapter)
    }
}

extension WithObservableViewModel: View where Content: View {
    var body: Content {
        content(observableViewModel)
    }
}
