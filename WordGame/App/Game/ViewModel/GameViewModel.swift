//
//  GameViewModel.swift
//  WordGame
//
//  Created by Ghalaab on 26/11/2022.
//

import Foundation
import Combine

enum Attempt {
    case correct
    case wrong
}

final class GameViewModel {
    
    private let gameEngine: GameEngineType
    private var cancellables = Set<AnyCancellable>()
    
    init(gameEngine: GameEngineType = GameEngine()) {
        self.gameEngine = gameEngine
        
        Publishers.CombineLatest(
            gameEngine.outputs.word,
            Just(gameEngine.outputs.score)
        )
        .print("gameEngine")
        .sink { _ in }
        .store(in: &cancellables)
    }
}
