//
//  Football Leaderboard.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 26/09/2024.
//

import SwiftUI




struct FootballLeaderboard: View {
    @AppStorage("username") var username : String = ""
    @State var num: Int = 0
    @State var isUser: Bool = false
    
    @StateObject var viewModel = LeaderboardViewModel()
    
    @State var showTerms = true
    var body: some View {
        NavigationView {
            ZStack {
//                Rectangle()
//                    .foregroundStyle(Color(.systemGray))
//                    .blur(radius: 15)
//                    .ignoresSafeArea()
                
                BackdropBlurView(radius: 13)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        //                    Text ("Football Leaderboard")
                        //                        .font(.largeTitle)
                        //                        .bold()
                        
                        HStack {
                            Text("Name")
                                .bold()
                            
                            Spacer()
                            
                            Text ("Minutes played")
                                .bold()
                        }.padding()
                        
                        LazyVStack {
                            ForEach(Array(viewModel.leaderResult.top10.enumerated()), id: \.element.id) { (idx, person) in
                                if username == person.username {
                                    ZStack {
//                                        RoundedRectangle(cornerRadius: 10)
//                                            .foregroundStyle(.orange)
//                                            .frame(width: 10, height: 10)
                                        
                                        HStack {
                                            
                                            Text("\(idx + 1)")
                                            Text(person.username)
                                                .font(.headline)
                                            
                                            Image(systemName: "person.fill")
                                                .foregroundStyle(.orange)
                                            
                                            
                                            Spacer()
                                            
                                            Text("\(person.count) minutes")
                                                .font(.headline)
                                        }
                                        .padding(.horizontal)
                                        .padding(8)
                                    }
                                    
                                    
                                } else if idx == 0 {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(.orange)
                                            .background(.thinMaterial)
                                            .opacity(0.4)
                                            .frame(width: 380, height: 40)
                                        
                                        HStack {
                                            
                                            Text("\(idx + 1)")
                                            Text(person.username)
                                                .font(.headline)
                                            
                                            Image(systemName: "crown.fill")
                                            .foregroundStyle(.orange)
                                            
                                            
                                            Spacer()
                                            
                                            Text("\(person.count) minutes")
                                                .font(.headline)
                                        }
                                        .padding(.horizontal)
                                        .padding(8)
                                    }
                                } else {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .background(.thinMaterial)
                                            .frame(width: 380, height: 40)
                                        
                                        HStack {
                                            
                                            Text("\(idx + 1)")
                                            Text(person.username)
                                                .font(.headline)
                                            
                                            //Image(systemName: "crown.fill")
                                            //.foregroundStyle(.orange)
                                            
                                            
                                            Spacer()
                                            
                                            Text("\(person.count) minutes")
                                                .font(.headline)
                                        }
                                        .padding(.horizontal)
                                        .padding(8)
                                    }
                                }
                            }
                        }
                        
                        
                        
                        if let user = viewModel.leaderResult.user {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            HStack {
                                Text(user.username)
                                    .font(.headline)
                                
                                Image(systemName: "person.fill")
                                    .foregroundStyle(.orange)
                                
                                Spacer()
                                
                                Text("\(user.count) minutes")
                                    .font(.headline)
                            }
                            .padding(.horizontal)
                            .padding(10)
                        }
                        
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                }
                
                
            }
        }.navigationTitle("Football Leaderboard")
        
        
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
