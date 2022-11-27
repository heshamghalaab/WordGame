//
//  GameEngine.swift
//  WordGame
//
//  Created by Ghalaab on 27/11/2022.
//

import Foundation
import Combine

protocol GameEngineInputs {
    func startGame()
    func gamerDidChoose(attempt: Attempt)
}

protocol GameEngineOutputs {
    /// A CurrentValueSubject for the current question word
    var word: CurrentValueSubject<Word?, Never> { get }
    
    /// An Object for the score according the user Progress.
    var score: Score { get }
    
    /// A Counter for the question
    var counter: CurrentValueSubject<Int, Never> { get }
    
    /// The Rules of the game
    var rules: Rules { get }
}

protocol GameEngineType {
    var inputs: GameEngineInputs { get }
    var outputs: GameEngineOutputs { get }
}

final class GameEngine: GameEngineType, GameEngineInputs, GameEngineOutputs {
    
    private struct Game {
        struct Current {
            var words: [Word] = []
            var attempt: Attempt = .correct
            var wordIndex: Int = -1
        }
        
        var current: Current = Current()
    }
    
    var inputs: GameEngineInputs { self }
    var outputs: GameEngineOutputs { self }
    
    private let wordsProvider: WordsProvidable
    private var game: Game = Game()
    private let timer: TimerType
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?
    
    init(
        wordsProvider: WordsProvidable = WordsProvider(),
        rules: Rules = Rules(),
        timer: TimerType = Timer.publish(every: 1, on: .main, in: .default)
    ) {
        self.wordsProvider = wordsProvider
        self.rules = rules
        self.timer = timer
        self.startGame()
    }
    
    // MARK: Outputs
    
    var word = CurrentValueSubject<Word?, Never>(nil)
    var score: Score = Score()
    var rules: Rules
    var counter = CurrentValueSubject<Int, Never>(0)
    
    // MARK: Inputs
    
    func startGame() {
        loadWords()
    }
    
    func gamerDidChoose(attempt: Attempt) {
        stopCounting()
        score.calculateScore(
            currentAttempt: game.current.attempt,
            selectedAttempt: attempt
        )
        loadNextQuestion()
    }
}

// MARK: Logic

private extension GameEngine {

    /// Will do the needed changes to load the next word for the user
    func loadNextQuestion() {
        game.current.wordIndex += 1
        guard shouldProceedToNextQuestion() else {
            endGame()
            return
        }
        setCurrentAttempt()
        word.value = nextWord()
        startCounting()
    }
    
    /// Will Chech for the Rules in order to know if we should to proceed or not.
    func shouldProceedToNextQuestion() -> Bool {
        return game.current.wordIndex < rules.maximumNumberOfQuestion
        && game.current.wordIndex < game.current.words.count
        && score.wrongAttempts < rules.maximumNumberOfWrongAttempts
    }
        
    /// Will Load the Words from the Json File and After Completion it will load the next question.
    func loadWords(){
        wordsProvider
            .wordsPublisher
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.loadNextQuestion()
            }, receiveValue: { [weak self] words in
                self?.game.current.words = words.shuffled()
            })
            .store(in: &cancellables)
    }
    
    /// Will Set the current Attempt from the probability of correctness rule which is by default = 25%
    func setCurrentAttempt() {
        let randomPercentage = Int.random(in: 0...100)
        switch randomPercentage {
        case 0..<rules.probabilityOfCorrectness: game.current.attempt = .correct
        case rules.probabilityOfCorrectness...100: game.current.attempt = .wrong
        default: break
        }
    }
    
    /// The Aim of this function is to change the text spanish to a random text if the current attempt is wrong.
    /// - Returns: The Current word if current attempt is correct, else will return the current word with a random wrong spanish text.
    func nextWord() -> Word {
        var word = game.current.words[game.current.wordIndex]
        if game.current.attempt == .wrong {
            word.textSpanish = game.current.words[randomSpanishIndex].textSpanish
        }
        return word
    }
    
    /// Will Select a random index from the array count excluding the current index.
    /// This Variable is called only of the current attempt is wrong.
    var randomSpanishIndex: Int {
        // As We need to exclude the current word index So we will create two ranges arround that index
        let range = 0...game.current.wordIndex
        let anotherRange = game.current.wordIndex..<game.current.words.count
        // Then we will choose a random rande from the two ranges to select the random Int from them.
        return Bool.random() ? Int.random(in: range) : Int.random(in: anotherRange)
    }
    
    func endGame() {
        stopCounting()
        // Beside Hidding the last question Sending nil will also make the
        // viewModel receive the final update of the score
        word.send(nil)
    }
}

// MARK: Timer Logic

private extension GameEngine {
    
    /// Start Counting with 1 second interval, if the counter exceeds the time limit we will mark it as wrong answer.
    func startCounting() {
        timerCancellable = timer
            .timerPublisher()
            .scan(0) { counter, _ in counter + 1 }
            .sink { [weak self] counter in
                guard let self = self else { return }
                self.counter.value = counter
                if counter >= self.rules.timeLimit {
                    self.markAttemptAsWrong()
                }
            }
    }
    
    /// Force Attempt to be wrong so we will toggle the value of the current attempt and acting like the user choose wrong attempt.
    func markAttemptAsWrong(){
        stopCounting()
        let attempt: Attempt = game.current.attempt == .correct ? .wrong : .correct
        self.gamerDidChoose(attempt: attempt)
    }
    
    /// Stop Counting by cancelling the timer cancellable.
    func stopCounting() {
        timerCancellable?.cancel()
    }
}
