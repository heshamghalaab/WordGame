//
//  Word+wordsMock.swift
//  WordGameTests
//
//  Created by Ghalaab on 29/11/2022.
//

import Foundation

@testable import WordGame

extension Word {
    static var wordsMock: [Word] {
        [
            Word(textEnglish: "primary school", textSpanish: "escuela primaria"),
            Word(textEnglish: "teacher", textSpanish: "profesor / profesora"),
            Word(textEnglish: "pupil", textSpanish: "alumno / alumna"),
            Word(textEnglish: "holidays", textSpanish: "vacaciones "),
            Word(textEnglish: "class", textSpanish: "curso"),
            Word(textEnglish: "bell", textSpanish: "timbre"),
            Word(textEnglish: "group", textSpanish: "grupo"),
            Word(textEnglish: "exercise book", textSpanish: "cuaderno"),
            Word(textEnglish: "quiet", textSpanish: "quieto"),
            Word(textEnglish: "(to) answer", textSpanish: "responder"),
            Word(textEnglish: "headteacher", textSpanish: "director del colegio / directora del colegio"),
            Word(textEnglish: "state school", textSpanish: "colegio público"),
            Word(textEnglish: "private school", textSpanish: "colegio privado"),
            Word(textEnglish: "school bus", textSpanish: "autobús escolar"),
            Word(textEnglish: "trick", textSpanish: "jugarreta"),
            Word(textEnglish: "pair", textSpanish: "pareja"),
            Word(textEnglish: "exercise", textSpanish: "ejercicio"),
            Word(textEnglish: "lunch box", textSpanish: "fiambrera")
        ]
    }
}
