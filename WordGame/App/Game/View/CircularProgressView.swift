//
//  CircularProgressView.swift
//  WordGame
//
//  Created by Ghalaab on 27/11/2022.
//

import SwiftUI


struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.black.opacity(0.5),
                    lineWidth: 5
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.black,
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.5)
    }
}
