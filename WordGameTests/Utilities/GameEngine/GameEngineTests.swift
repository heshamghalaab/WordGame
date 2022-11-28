//
//  GameEngineTests.swift
//  WordGameTests
//
//  Created by Ghalaab on 28/11/2022.
//

import XCTest
import Combine
import CombineSchedulers

@testable import WordGame

final class GameEngineTests: XCTestCase {
    
    var sut: GameEngineType!
    var wordsProviderMock: WordsProvidable!
    var rules: Rules!
    var cancellables = Set<AnyCancellable>()
    
    func testWordOutputWhenWordsIsEmpty(){
        // Given
        setupGameEngineSut(withWords: [])
        
        var receviedWord: Word? = nil
        sut.outputs.word
            .dropFirst()
            .sink { word in
                receviedWord = word
            }.store(in: &cancellables)
        
        // When
        sut.inputs.startGame()
        
        // Then
        XCTAssertNil(receviedWord)
    }
    
    func testWordOutputWhenWordsExists(){
        // Given
        setupGameEngineSut()
        
        var receviedWord: Word? = nil
        sut.outputs.word
            .dropFirst()
            .sink { word in
                receviedWord = word
            }.store(in: &cancellables)
        
        // When
        sut.inputs.startGame()
        
        // Then
        XCTAssertNotNil(receviedWord)
    }
    
    func testWordWhenTheRandomAttemptIsSelected() {
        // Given
        setupGameEngineSut()
        
        var receviedWord: Word? = nil
        sut.outputs.word
            .dropFirst()
            .sink { word in
                receviedWord = word
            }.store(in: &cancellables)
        
        // When
        sut.inputs.startGame()
        let realWord = sut.outputs.game.current.words.first {
            $0.textEnglish == receviedWord?.textEnglish
        }
        
        // Then
        switch sut.outputs.game.current.attempt {
        case .correct: XCTAssertEqual(realWord?.textSpanish, receviedWord?.textSpanish)
        case .wrong: XCTAssertNotEqual(realWord?.textSpanish, receviedWord?.textSpanish)
        }
    }
    
    func testScoreWhenGamerChooseCorrectAttempt() {
        // Given
        setupGameEngineSut()
        
        // On Initialize
        XCTAssertEqual(sut.outputs.score.correctAttempts, 0)
        XCTAssertEqual(sut.outputs.score.wrongAttempts, 0)
        
        // When
        sut.inputs.startGame()
        sut.inputs.gamerDidChoose(attempt: sut.outputs.game.current.attempt)
        
        // Then
        XCTAssertEqual(sut.outputs.score.correctAttempts, 1)
        XCTAssertEqual(sut.outputs.score.wrongAttempts, 0)
    }
    
    func testScoreWhenGamerChooseWrongAttempt() {
        // Given
        setupGameEngineSut()
        
        // On Initialize
        XCTAssertEqual(sut.outputs.score.correctAttempts, 0)
        XCTAssertEqual(sut.outputs.score.wrongAttempts, 0)
        
        // When
        sut.inputs.startGame()
        sut.inputs.gamerDidChoose(attempt: sut.outputs.game.current.attempt.toggle)
        
        // Then
        XCTAssertEqual(sut.outputs.score.correctAttempts, 0)
        XCTAssertEqual(sut.outputs.score.wrongAttempts, 1)
    }
    
    func testScoreWhenReachingTimeLimit() {
        // Given
        let timerSchedular = DispatchQueue.test
        setupGameEngineSut(rules: Rules(timeLimit: 1), timerSchedular: timerSchedular.eraseToAnyScheduler())
        
        // When
        sut.inputs.startGame()
        timerSchedular.advance(by: 1.1)
        
        // Then
        XCTAssertEqual(sut.outputs.score.correctAttempts, 0)
        XCTAssertEqual(sut.outputs.score.wrongAttempts, 1)
    }
    
    func testGameEndedWhenReachingMaximumNumberOfWrongAttempts() {
        // Given
        setupGameEngineSut()
        sut.inputs.startGame()
        
        var gameEnded: Bool = false
        sut.outputs.gameEnded
            .dropFirst()
            .sink { gameEnded = $0 }
            .store(in: &cancellables)
        
        // When
        for _ in 0..<rules.maximumNumberOfWrongAttempts {
            sut.inputs.gamerDidChoose(attempt: sut.outputs.game.current.attempt.toggle)
        }
        
        // Then
        XCTAssertTrue(gameEnded)
    }
    
    func testGameEndedWhenReachingMaximumNumberOfQuestions() {
        // Given
        setupGameEngineSut()
        sut.inputs.startGame()
        
        var gameEnded: Bool = false
        sut.outputs.gameEnded
            .dropFirst()
            .sink { gameEnded = $0 }
            .store(in: &cancellables)
        
        // When
        for _ in 0..<rules.maximumNumberOfQuestions {
            sut.inputs.gamerDidChoose(attempt: sut.outputs.game.current.attempt)
        }
        
        // Then
        XCTAssertTrue(gameEnded)
    }
    
    func testGameWhenGamerRestartIt() {
        // Given
        setupGameEngineSut()
        sut.inputs.startGame()
        
        // When
        for _ in 0..<rules.maximumNumberOfQuestions {
            sut.inputs.gamerDidChoose(attempt: sut.outputs.game.current.attempt)
        }
        sut.inputs.restartGame()
        
        // Then
        XCTAssertFalse(sut.outputs.gameEnded.value)
        XCTAssertEqual(sut.outputs.score.correctAttempts, 0)
        XCTAssertEqual(sut.outputs.score.wrongAttempts, 0)
    }
    
    func setupGameEngineSut(
        withWords words: [Word] = Word.wordsMock,
        rules: Rules = Rules(),
        timerSchedular: AnySchedulerOf<DispatchQueue> = DispatchQueue.test.eraseToAnyScheduler()
    ) {
        self.wordsProviderMock = WordsProviderMock(words: words)
        self.rules = rules
        self.sut = GameEngine(wordsProvider: wordsProviderMock, rules: rules, timerSchedular: timerSchedular)
    }
}
