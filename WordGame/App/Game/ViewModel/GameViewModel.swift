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

final class GameViewModel: ViewModel {
    
    private let gameEngine: GameEngineType
    
    init(gameEngine: GameEngineType = GameEngine()) {
        self.gameEngine = gameEngine
    }
    
    var adapter: ViewModelAdapter<GameView.ViewState, GameView.Action> {
        .init(
            initialState: .empty,
            query: viewStatePublisher,
            send: { [weak self] in self?.handle(action: $0) }
        )
    }
    
    private var viewStatePublisher: AnyPublisher<GameView.ViewState, Never> {
        Publishers.CombineLatest4(
            gameEngine.outputs.word,
            gameEngine.outputs.counter,
            Just(gameEngine.outputs.rules),
            Just(gameEngine.outputs.score)
        )
        .map(toViewState)
        .eraseToAnyPublisher()
    }
    
    private func handle(action: GameView.Action) {
        switch action {
        case .attempt(let attempt):
            gameEngine.inputs.gamerDidChoose(attempt: attempt)
        }
    }
}

extension GameViewModel {
    func toViewState(word: Word?, counter: Int, rules: Rules, score: Score) -> GameView.ViewState {
        let progress = Double(counter) / Double(rules.timeLimit)
        
        return .init(
            correctAttemptsCountText: "Correct attempts: \(score.correctAttempts)",
            wrongAttemptsCountText: "Wrong attempts: \(score.wrongAttempts)",
            spanishText: word?.textSpanish ?? "",
            englishText: word?.textEnglish ?? "",
            counter: counter,
            progress: progress
        )
    }
}
