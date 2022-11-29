//
//  GameViewModelTests.swift
//  WordGameTests
//
//  Created by Ghalaab on 29/11/2022.
//

import XCTest

@testable import WordGame

final class GameViewModelTests: XCTestCase {

    var sut: GameViewModel!
    var gameEngineMock: GameEngineMock!
    var word: Word? = Word.wordsMock.first
    
    func testActionWhenGamerChooseAttempt() {
        setupSut()
        sut.adapter.send(.attempt(.correct))
        XCTAssertTrue(gameEngineMock.gamerDidChooseTriggered)
    }
    
    func testActionWhenRestartGame() {
        setupSut()
        sut.adapter.send(.restartGame)
        XCTAssertTrue(gameEngineMock.restartGameTriggered)
    }
    
    func testViewStateWhenWordExist() {
        setupSut()
        XCTAssertEqual(sut.adapter.state.englishText, word?.textEnglish)
        XCTAssertEqual(sut.adapter.state.spanishText, word?.textSpanish)
    }
    
    func testViewStateWhenWordDonotExist() {
        setupSut(word: nil)
        XCTAssertEqual(sut.adapter.state.englishText, "")
        XCTAssertEqual(sut.adapter.state.spanishText, "")
    }
    
    func testViewStateWhenGameEnded() {
        setupSut(gameEnded: true)
        XCTAssertTrue(sut.adapter.state.showGameEndedDialogue)
    }
    
    func setupSut(
        word: Word? = Word.wordsMock.first,
        game: GameEngine.Game = GameEngine.Game(),
        score: Score = Score(),
        rules: Rules = Rules(),
        counter: Double = 0,
        gameEnded: Bool = false
    ){
        gameEngineMock = GameEngineMock(
            word: word,
            game: game,
            score: score,
            rules: rules,
            counter: counter,
            gameEnded: gameEnded
        )
        sut = GameViewModel(gameEngine: gameEngineMock)
    }
}
