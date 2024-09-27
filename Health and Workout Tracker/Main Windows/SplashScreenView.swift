//
//  SplashScreenView.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 27/09/2024.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @StateObject var manager = HealthManager()
    
    var body: some View {
        VStack {
            if isActive {
                // Main content of the app after splash screen
                ContentView()
                    .environmentObject(manager)
            } else {
                // Your splash screen view
                VStack { // Using your preferred color
                    Image(systemName: "lungs") // Splash icon or logo
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.orange)
                }
                .onAppear {
                    // Delay for 1 second
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.easeInOut) {
                            self.isActive = true
                        }
                    }
                }
            }
        }
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SplashScreenView()
}
