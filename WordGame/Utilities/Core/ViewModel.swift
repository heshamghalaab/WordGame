//
//  ViewModel.swift
//  WordGame
//
//  Created by Ghalaab on 27/11/2022.
//

import Foundation

protocol ViewModel {
    associatedtype ViewState
    associatedtype Action
    
    var adapter: ViewModelAdapter<ViewState, Action> { get }
}
