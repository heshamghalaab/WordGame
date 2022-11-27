//
//  Word.swift
//  WordGame
//
//  Created by Ghalaab on 26/11/2022.
//

import Foundation

struct Word: Decodable {
    let textEnglish: String
    var textSpanish: String
    
    enum CodingKeys: String, CodingKey {
        case textEnglish = "text_eng"
        case textSpanish = "text_spa"
    }
}
