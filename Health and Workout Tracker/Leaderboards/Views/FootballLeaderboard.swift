//
//  Football Leaderboard.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 26/09/2024.
//

import SwiftUI




struct FootballLeaderboard: View {
    
    @State var num: Int = 0
    
    @StateObject var viewModel = LeaderboardViewModel()
    
    @State var showTerms = true
    var body: some View {
        ZStack {
            
            BackdropBlurView(radius: 13)
            
            VStack {
                Text ("Football Leaderboard")
                    .font(.largeTitle)
                    .bold()
                
                HStack {
                    Text("Name")
                        .bold()
                    
                    Spacer()
                    
                    Text ("Minutes played")
                        .bold()
                }.padding()
                
                LazyVStack {
                    ForEach(viewModel.leaders) { person in
                        HStack {
                            
                            Text("1")
                            Text(person.username)
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("\(person.count) minutes")
                                .font(.headline)
                        }
                        .padding(.horizontal)
                        .padding(10)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            

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
    FootballLeaderboard()
}
