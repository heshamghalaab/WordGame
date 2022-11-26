//
//  Word.swift
//  WordGame
//
//  Created by Ghalaab on 26/11/2022.
//

import Foundation

struct Word: Decodable {
    let textEng: String
    var textSpa: String
    
    enum CodingKeys: String, CodingKey {
        case textEng = "text_eng"
        case textSpa = "text_spa"
    }
}
