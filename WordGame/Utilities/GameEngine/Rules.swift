//
//  Rules.swift
//  WordGame
//
//  Created by Ghalaab on 27/11/2022.
//

import Foundation

struct Rules {
    let probabilityOfCorrectness: Int
    let maximumNumberOfQuestion: Int
    let maximumNumberOfWrongAttempts: Int
    let timeLimit: Double
    
    /// - Parameters:
    ///   - probabilityOfCorrectness: Will accept only the range from 0...100 probabilityOfCorrectness Else will add the **default value == 25**.
    ///   - maximumNumberOfQuestion: Number of questions that should be presented to the user **default value == 15**.
    ///   - maximumNumberOfWrongAttempts: Number of wrong attemps that should end the game **default value == 3**.
    ///   - timeLimit: Time Limit for the question to end and to be marker as a wrong answer **default value == 5**.
    init(
        probabilityOfCorrectness: Int = 25,
        maximumNumberOfQuestion: Int = 15,
        maximumNumberOfWrongAttempts: Int = 3,
        timeLimit: Double = 5.0
    ) {
        self.maximumNumberOfQuestion = maximumNumberOfQuestion
        self.maximumNumberOfWrongAttempts = maximumNumberOfWrongAttempts
        self.timeLimit = timeLimit
        
        if probabilityOfCorrectness >= 0, probabilityOfCorrectness <= 100 {
            self.probabilityOfCorrectness = probabilityOfCorrectness
        } else {
            self.probabilityOfCorrectness = 25
        }
    }
}
