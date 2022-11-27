//
//  Score.swift
//  WordGame
//
//  Created by Ghalaab on 27/11/2022.
//

import Foundation

class Score {
    var correctAttempts: Int = 0
    var wrongAttempts: Int = 0
    
    func calculateScore(currentAttempt: Attempt, selectedAttempt: Attempt) {
        if currentAttempt == selectedAttempt {
            correctAttempts += 1
        } else {
            wrongAttempts += 1
        }
    }
}
