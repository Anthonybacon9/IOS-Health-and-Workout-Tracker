//
//  ContentView.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 18/09/2024.
//

import SwiftUI
import UIKit

func getFormattedDate() -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .long // You can change to .short or .medium as needed
    formatter.timeStyle = .none // For date only, set timeStyle to .none
    return formatter.string(from: Date())
}

func getFormattedTime() -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .none // You can change to .short or .medium as needed
    formatter.timeStyle = .short // For date only, set timeStyle to .none
    return formatter.string(from: Date())
}

extension View {
    func applyScrollTransition(phase: ScrollTransitionPhase) -> some View {
        self
            .opacity(phase.isIdentity ? 1.0 : 0.0)
            .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3, y: phase.isIdentity ? 1.0 : 0.3)
    }
}

struct ContentView: View {
    //@EnvironmentObject var manager: HealthManager
    init() {
        setupTabBarAppearance()
    }
    
    @AppStorage("username") var username : String = ""
    @AppStorage("authenicated") var authenicated : Bool = false
    
    @State var backgroundColour: Color = Color(red: 247 / 255, green: 210 / 255, blue: 235 / 255)
    @State private var opacity = 1.0
    @State private var selectedTab = 0
    @State private var fitness = true
    //@State var backgroundColour: Color = Color.orange
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    TabView(selection: $selectedTab) {
                        FitnessPage(authenticated: $authenicated)
                            .tabItem {
                                Label("Fitness", systemImage: "figure.run")
                            }
                            .tag(0)
                            .onAppear() {
                                fitness = true
                            }
                        HealthPage()
                            .tabItem {
                                Label("Health", systemImage: "heart.fill")
                            }
                            .tag(1)
                            .onAppear() {
                                fitness = false
                            }
                    }.accentColor(fitness ? .green : .red)
                }
                
                Carousel()
                
                Spacer()
                
                //            BottomNavBar()
                //                .offset(y:335)
            }.navigationBarItems(leading: NavigationLink(
                destination: UserProfile(username: $username, authenticated: $authenicated),
            label: {
                Image(systemName: "person.fill")
                    .padding(10)
                    .foregroundStyle(.orange)
            }).accentColor(.white)
            
            )
        }
    }
    
    private func setupTabBarAppearance() {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.black // Set the background color of the tab bar

            // Customize selected and unselected tab bar item colors
            UITabBar.appearance().tintColor = UIColor.systemGreen // Selected item color
            UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray // Unselected item color
            
            // Apply to all tab bars
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    
    
    func Create() -> some View {
        return
        
        Button(action: {
            
        }, label: {
            Circle()
                .frame(width: 100)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .frame(width:70)
                        .foregroundColor(Color.red)
                        .overlay() {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color.white)
                        }
                }.offset(y:-40)
        }).buttonStyle(PlainButtonStyle())
    }
    
    func BottomNavBar() -> some View {
        return ZStack {
            HStack(spacing: 0){
                Button(action: {
                    
                }, label: {
                    Rectangle()
                        .background(.ultraThinMaterial)
                        .opacity(0.7)
                        .overlay {
                            Image(systemName: "heart.text.square.fill")
                                .font(.largeTitle)
                                .offset(x: -20, y: -15)
                                .foregroundStyle(Color.white)
                        }
                }).buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    
                }, label: {
                    Rectangle()
                        .background(.ultraThinMaterial)
                        .opacity(0.7)
                        .overlay {
                            Image(systemName: "figure.run")
                                .font(.largeTitle)
                                .offset(x: 20, y: -15)
                            //.padding(.horizontal, 65)
                                .foregroundStyle(Color.white)
                        }
                }).buttonStyle(PlainButtonStyle())
                
            }.offset(y:25)
            
            Create()
        }
        .frame(height: 130)
    }
}


struct Carousel: View {
    @State private var animateBackground = false
    @State private var currentImageIndex = 0
        let systemImages = ["heart.fill","bolt.fill", "flame.fill", "waveform.path.ecg", "figure.open.water.swim", "figure.mind.and.body", "figure.soccer", "lungs.fill", "figure.roll.runningpace", "figure.cooldown"]
        
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(systemImages, id: \.self) { systemImage in
                    Image(systemName: systemImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .opacity(0.1) // Subtle background effect
                }
            }
            .frame(width: geometry.size.width * CGFloat(systemImages.count), height: geometry.size.height)
            .offset(x: animateBackground ? -geometry.size.width * CGFloat(systemImages.count - 1) : 0)
            .animation(Animation.linear(duration: 200).repeatForever(autoreverses: false), value: animateBackground)
            .onAppear {
                animateBackground = true
            }
        }
        .ignoresSafeArea()
    }
}


#Preview {
    ContentView()
        .environmentObject(HealthManager())
}
