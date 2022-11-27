//
//  Rules.swift
//  WordGame
//
//  Created by Ghalaab on 27/11/2022.
//

import Foundation

struct Rules {
    let probabilityOfCorrectness: Int
    
    /// Will accept only the range from 0...100 probabilityOfCorrectness Else will add the default Value.
    init(probabilityOfCorrectness: Int = 25) {
        if probabilityOfCorrectness >= 0, probabilityOfCorrectness <= 100 {
            self.probabilityOfCorrectness = probabilityOfCorrectness
        } else {
            self.probabilityOfCorrectness = 25
        }
    }
}
