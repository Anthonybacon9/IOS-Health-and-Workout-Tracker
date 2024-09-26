//
//  Football Leaderboard.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 26/09/2024.
//

import SwiftUI

struct Football_Leaderboard: View {
    var body: some View {
        ZStack {
            Image(systemName: "figure.outdoor.soccer")
                .resizable()
                .scaledToFit()
            
            
            
            Text ("Football Leaderboard")
                .font(.largeTitle)
                .bold()
        }
    }
}

struct BackdropView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        let blur = UIBlurEffect()
        let animator = UIViewPropertyAnimator()
        animator.addAnimations { view.effect = blur }
        animator.fractionComplete = 0
        animator.stopAnimation(false)
        animator.finishAnimation(at: .current)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
    
}

/// A transparent View that blurs its background
struct BackdropBlurView: View {
    
    let radius: CGFloat
    
    @ViewBuilder
    var body: some View {
        BackdropView().blur(radius: radius)
    }
    
}

#Preview {
    Football_Leaderboard()
}
