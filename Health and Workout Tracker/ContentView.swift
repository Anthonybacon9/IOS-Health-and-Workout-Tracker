//
//  ContentView.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 18/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var animateBackground = false
    @State var backgroundColour: Color = Color(red: 247 / 255, green: 210 / 255, blue: 235 / 255)
    @State private var currentImageIndex = 0
        let systemImages = ["heart.fill","bolt.fill", "flame.fill", "waveform.path.ecg", "figure.open.water.swim", "figure.mind.and.body", "figure.soccer", "lungs.fill"]
    
    
    
    
    
    
    var body: some View {
        ZStack {
            Color(backgroundColour)
                .ignoresSafeArea()
            
            Carousel()
            
            Spacer()
            
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                            .font(.title)
                            //.padding(.bottom, 30)
                        
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
                            }
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.0)
                                    .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3, y: phase.isIdentity ? 1.0 : 0.3)
                            }
                        
                        RoundedRectangle(cornerRadius: 15)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(width: 380, height:190 )
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.0)
                                    .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3, y: phase.isIdentity ? 1.0 : 0.3)
                            }
                        
                        
                        RoundedRectangle(cornerRadius: 15)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(width: 380, height:190 )
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.0)
                                    .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3, y: phase.isIdentity ? 1.0 : 0.3)
                            }
                        
                        RoundedRectangle(cornerRadius: 15)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(width: 380, height:190 )
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.0)
                                    .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3, y: phase.isIdentity ? 1.0 : 0.3)
                            }
                        RoundedRectangle(cornerRadius: 15)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(width: 380, height:190 )
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.0)
                                    .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3, y: phase.isIdentity ? 1.0 : 0.3)
                            }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(.vertical, 40, for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)
                //.ignoresSafeArea()
                
                Spacer()

            }
            BottomNavBar()
                .offset(y:335)
        }
    }
    
    func Carousel() -> some View {
        return GeometryReader { geometry in
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

#Preview {
    ContentView()
}
