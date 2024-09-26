//
//  Football Leaderboard.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 26/09/2024.
//

import SwiftUI

struct LeaderboardFUser: Codable, Identifiable {
    let id: Int
    let createdAt: String
    let username: String
    let count: Int
    
    //Country
}

class LeaderboardViewModel: ObservableObject {
    var mockData = [
        LeaderboardFUser(id: 1, createdAt: "", username: "Anthony Bacon", count: 1100),
        LeaderboardFUser(id: 2, createdAt: "", username: "John Doe", count: 1000 ),
        LeaderboardFUser(id: 3, createdAt: "", username: "John Doe", count: 1000 ),
        LeaderboardFUser(id: 4, createdAt: "", username: "John Doe", count: 1000 ),
        LeaderboardFUser(id: 5, createdAt: "", username: "John Doe", count: 1000 ),
        LeaderboardFUser(id: 6, createdAt: "", username: "John Doe", count: 1000 )
    ]
}

struct FootballLeaderboard: View {
    
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
                    ForEach(viewModel.mockData) { person in
                        HStack {
                            
                            Text("\(person.id)")
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
