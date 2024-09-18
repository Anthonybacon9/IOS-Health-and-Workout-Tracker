//
//  ContentView.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 18/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var animateBackground = false
    @State var backgroundColour: Color = .green
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
                            .padding(.bottom, 100)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 380, height:190 )
                        RoundedRectangle(cornerRadius: 10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 380, height:190 )
                    }
                }
                
                Spacer()
                
                ZStack {
                    HStack(spacing: 0){
                        Rectangle()
                            .background(.ultraThinMaterial)
                            .opacity(0.7)
//                            .foregroundStyle(Color(hue: 0.537, saturation: 1.0, brightness: 1.0))
                            .overlay {
                                Image(systemName: "heart.text.square.fill")
                                    .font(.largeTitle)
                                    //.padding(.horizontal, 65)
                                    .foregroundStyle(Color.white)
                            }
                        Rectangle()
                            .background(.ultraThinMaterial)
                            .opacity(0.7)
//                            .foregroundStyle(Color(hue: 0.537, saturation: 1.0, brightness: 0.68))
                            .overlay {
                                Image(systemName: "figure.run")
                                    .font(.largeTitle)
                                    //.padding(.horizontal, 65)
                                    .foregroundStyle(Color.white)
                            }
                    }.offset(y:40)
                    
                    Circle()
                        //.foregroundColor(backgroundColour)
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
                        }.offset(y:-10)
                }
                .frame(height: 100)
            }
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
            .animation(Animation.linear(duration: 50).repeatForever(autoreverses: false), value: animateBackground)
            .onAppear {
                animateBackground = true
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
