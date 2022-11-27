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
        let showGameEndedDialogue: Bool
    }
    
    enum Action {
        case attempt(Attempt)
        case restartGame
        case closeApp
    }
    
    private var viewModelAdapter: ViewModelAdapter<ViewState, Action>
    
    init(viewModelAdapter: ViewModelAdapter<ViewState, Action> = GameViewModel().adapter) {
        self.viewModelAdapter = viewModelAdapter
    }
    
    var body: some View {
        WithObservableViewModel(viewModelAdapter) { vm in
            ZStack {
                VStack {
                    topView
                    Spacer()
                    wordView.padding()
                    Spacer()
                    bottomView.padding(.horizontal, 16)
                }
                .blur(radius: vm.viewState.showGameEndedDialogue ? 10 : 0)
                if vm.viewState.showGameEndedDialogue {
                    withAnimation {
                        dialogueView
                    }    
                }
            }
        }
    }
    
    var topView: some View {
        HStack {
            ZStack {
                CircularProgressView(progress: viewModelAdapter.state.progress)
                Text("\(viewModelAdapter.state.counter)").font(.system(size: 10))
            }.frame(width: 25, height: 25)
            Spacer()
            VStack(alignment: .trailing) {
                Text(viewModelAdapter.state.correctAttemptsCountText)
                    .fontWeight(.bold)
                Text(viewModelAdapter.state.wrongAttemptsCountText)
                    .fontWeight(.bold)
            }
        }.padding(.horizontal, 16)
    }
    
    var wordView: some View {
        VStack(alignment: .center) {
            Text(viewModelAdapter.state.spanishText)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            Text(viewModelAdapter.state.englishText)
                .font(.title2)
                .lineLimit(nil)
        }.background(Color.yellow)
    }
    
    var bottomView: some View {
        HStack(spacing: 16) {
            Button {
                viewModelAdapter.send(.attempt(.correct))
            } label: {
                Text("Correct")
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            Button {
                viewModelAdapter.send(.attempt(.wrong))
            } label: {
                Text("Wrong")
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(8)
            }
        }
    }
    
    var dialogueView: some View {
        
        VStack {
            Spacer()
            
            VStack {
                Text("Game Ended")
                    .font(.largeTitle)
                    
                Text(viewModelAdapter.state.correctAttemptsCountText)
                    .font(.title)
                    
                Text(viewModelAdapter.state.wrongAttemptsCountText)
                    .font(.title)
                
                HStack {
                    Button {
                        viewModelAdapter.send(.closeApp)
                    } label: {
                        Text("Close App")
                            .frame(maxWidth: .infinity, maxHeight: 44)
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        viewModelAdapter.send(.restartGame)
                    } label: {
                        Text("Restart Game")
                            .frame(maxWidth: .infinity, maxHeight: 44)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding(.all)
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(Color.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
        .edgesIgnoringSafeArea(.all)
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
            progress: 0,
            showGameEndedDialogue: false
        )
    }
}
