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
        let counter: Double
        let animationProgress: Double
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
                    headerView
                    Spacer()
                    wordView.padding()
                    Spacer()
                    footerView.padding(.horizontal, 16)
                }
                .blur(radius: vm.viewState.showGameEndedDialogue ? 10 : 0)
                .animation(.spring(), value: viewModelAdapter.state.showGameEndedDialogue)
                
                dialogueView
            }
        }
    }
    
    var headerView: some View {
        HStack {
            ZStack {
                CircularProgressView(progress: viewModelAdapter.state.animationProgress)
                Text(String(format: "%.1f", viewModelAdapter.state.counter)).font(.system(size: 10))
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
                .offset(y: spanishTextYOffset)
                .animation(.easeInOut, value: viewModelAdapter.state.animationProgress)
            
            Text(viewModelAdapter.state.englishText)
                .font(.title2)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
    }
    
    var spanishTextYOffset: CGFloat {
        return viewModelAdapter.state.animationProgress >= 1 ? -100 : (viewModelAdapter.state.animationProgress-1) * 100
    }
    
    var footerView: some View {
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
            .scaleEffect(viewModelAdapter.state.showGameEndedDialogue ? 1 : 0.1)
            .offset(y: viewModelAdapter.state.showGameEndedDialogue ? 0 : 500)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(viewModelAdapter.state.showGameEndedDialogue ? Color.black.opacity(0.8) : Color.clear)
        .edgesIgnoringSafeArea(.all)
        .animation(.spring(), value: viewModelAdapter.state.showGameEndedDialogue)
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
            animationProgress: 0,
            showGameEndedDialogue: false
        )
    }
}
