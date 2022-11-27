//
//  GameView.swift
//  WordGame
//
//  Created by Ghalaab on 26/11/2022.
//

import SwiftUI
import Combine

struct GameView: View {
    
    struct ViewState {
        let correctAttemptsCountText: String
        let wrongAttemptsCountText: String
        let spanishText: String
        let englishText: String
        let counter: Int
        let progress: Double
    }
    
    enum Action {
        case attempt(Attempt)
    }
    
    private var viewModelAdapter: ViewModelAdapter<ViewState, Action>
    
    init(viewModelAdapter: ViewModelAdapter<ViewState, Action> = GameViewModel().adapter) {
        self.viewModelAdapter = viewModelAdapter
    }
    
    var body: some View {
        
        WithObservableViewModel(viewModelAdapter) { vm in
            VStack {
                HStack {
                    ZStack {
                        CircularProgressView(progress: vm.viewState.progress)
                        Text("\(vm.viewState.counter)")
                            .font(.system(size: 10))
                    }.frame(width: 25, height: 25)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(vm.viewState.correctAttemptsCountText)
                            .fontWeight(.bold)
                        Text(vm.viewState.wrongAttemptsCountText)
                            .fontWeight(.bold)
                    }
                }.padding(.horizontal, 16)
                
                Spacer()
                
                
                VStack(alignment: .center) {
                    Text(vm.viewState.spanishText)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                    Text(vm.viewState.englishText)
                        .font(.title2)
                        .lineLimit(nil)
                }.padding()
                
                Spacer()
                HStack(spacing: 16) {
                    Button {
                        vm.send(.attempt(.correct))
                    } label: {
                        Text("Correct")
                            .frame(maxWidth: .infinity, maxHeight: 44)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(8)
                    }

                    Button {
                        vm.send(.attempt(.wrong))
                    } label: {
                        Text("Wrong")
                            .frame(maxWidth: .infinity, maxHeight: 44)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

extension GameView.ViewState {
    static var empty: GameView.ViewState {
        .init(
            correctAttemptsCountText: "Correct attempts: 0",
            wrongAttemptsCountText: "Wrong attempts: 0",
            spanishText: "",
            englishText: "",
            counter: 0,
            progress: 0
        )
    }
}
