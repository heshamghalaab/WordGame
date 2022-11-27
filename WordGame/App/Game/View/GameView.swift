//
//  GameView.swift
//  WordGame
//
//  Created by Ghalaab on 26/11/2022.
//

import SwiftUI

struct GameView: View {
    
    struct ViewState {
        let correctAttemptsCountText: String
        let wrongAttemptsCountText: String
        let spanishText: String
        let englishText: String
    }
    
    enum Action {
        case attempt(Attempt)
    }
    
    private var viewModelAdapter: ViewModelAdapter<ViewState, Action>
    
    init(viewModelAdapter: ViewModelAdapter<ViewState, Action> = GameViewModel().adapter) {
        self.viewModelAdapter = viewModelAdapter
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Correct attempts: 0")
                        .fontWeight(.bold)
                    Text("Wrong attempts: 0")
                        .fontWeight(.bold)
                }
            }.padding(.horizontal, 16)
            
            Spacer()
            
            VStack(alignment: .center) {
                Text("fiambrera")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                Text("lunch box")
                    .font(.title2)
                    .lineLimit(nil)
            }.padding()
            
            Spacer()
            HStack(spacing: 16) {
                Button {
                    print("Correct")
                } label: {
                    Text("Correct")
                        .frame(maxWidth: .infinity, maxHeight: 44)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(8)
                }
                
                Button {
                    print("Wrong")
                } label: {
                    Text("Wrong")
                        .frame(maxWidth: .infinity, maxHeight: 44)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }.padding(.horizontal, 16)
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
            correctAttemptsCountText: "",
            wrongAttemptsCountText: "",
            spanishText: "",
            englishText: ""
        )
    }
}
