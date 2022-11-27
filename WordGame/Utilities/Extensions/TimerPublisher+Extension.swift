//
//  TimerPublisher+Extension.swift
//  WordGame
//
//  Created by Ghalaab on 27/11/2022.
//

import Foundation
import Combine

protocol TimerType {
    func timerPublisher() -> AnyPublisher<Date, Never>
}

extension Timer.TimerPublisher: TimerType {
    func timerPublisher() -> AnyPublisher<Date, Never> {
        self
            .autoconnect()
            .eraseToAnyPublisher()
    }
}
