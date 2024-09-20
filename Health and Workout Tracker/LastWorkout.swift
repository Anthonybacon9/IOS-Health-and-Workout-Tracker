//
//  SwiftUIView.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 19/09/2024.
//

import SwiftUI

struct LastWorkout: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .frame(width: 380, height:190 )
            .overlay {
                Text("Last Workout")
                    .font(.headline)
                    .frame(width:350, height:160, alignment:.topLeading)
                    .foregroundStyle(.white)
                    .opacity(0.5)
                Text("FOOTBALL")
                    .font(.headline)
                    .frame(width:350, height:160, alignment:.center)
                    .foregroundStyle(.white)
                    .opacity(0.5)
            }
//            .scrollTransition { content, phase in
//                content
//                    .opacity(phase.isIdentity ? 1.0 : 0.0)
//                    .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3, y: phase.isIdentity ? 1.0 : 0.3)
//            }
    }
}

#Preview {
    LastWorkout()
}
