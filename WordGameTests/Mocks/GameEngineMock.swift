//
//  GameEngineMock.swift
//  WordGameTests
//
//  Created by Ghalaab on 29/11/2022.
//

import Foundation
import Combine

@testable import WordGame

final class GameEngineMock: GameEngineType, GameEngineInputs, GameEngineOutputs {
    
    var inputs: GameEngineInputs { self }
    var outputs: GameEngineOutputs { self }
    
    init(
        word: Word? = Word.wordsMock.first,
        game: GameEngine.Game = GameEngine.Game(),
        score: Score = Score(),
        rules: Rules = Rules(),
        counter: Double = 0,
        gameEnded: Bool = false
    ) {
        self.word = .init(word)
        self.game = game
        self.score = score
        self.rules = rules
        self.gameEnded = .init(gameEnded)
        self.counter = .init(counter)
        self.startGame()
    }
    
    // MARK: Outputs
    
    var word: CurrentValueSubject<Word?, Never>
    var score: Score
    var rules: Rules
    var counter: CurrentValueSubject<Double, Never>
    var gameEnded: CurrentValueSubject<Bool, Never>
    var game: GameEngine.Game
    
    // MARK: Inputs
    
    func startGame() { }
    
    var gamerDidChooseTriggered: Bool = false
    func gamerDidChoose(attempt: Attempt) {
        gamerDidChooseTriggered = true
    }
    
    var restartGameTriggered: Bool = false
    func restartGame() {
        restartGameTriggered = true
    }
}

