//
//  GameViewModel.swift
//  WordGame
//
//  Created by Ghalaab on 26/11/2022.
//

import Foundation
import Combine

final class GameViewModel {
    
    private let wordsProvider: WordsProvidable
    private var cancellables = Set<AnyCancellable>()
    
    init(wordsProvider: WordsProvidable = WordsProvider()) {
        self.wordsProvider = wordsProvider
        
        wordsProvider
            .wordsPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { words in
                print(words)
            })
            .store(in: &cancellables)
    }
}
