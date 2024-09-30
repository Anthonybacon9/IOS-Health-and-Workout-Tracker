//
//  BMIDetails.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 20/09/2024.
//

import SwiftUI

struct BMI {
    let height: Double
    let weight: Double
}

struct BMIDetailView: View {
    var health: Health?
    var bmi: BMI
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                        Image(systemName: "heart.text.square")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .opacity(0.1) // Subtle background effect
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 20) { // Add spacing between elements
                if let health = health {
                    Text(health.title)
                        .font(.largeTitle)
                        .fontWeight(.bold) // Emphasize the title
                        .foregroundColor(.primary) // Use primary color for title
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .center) // Center the title
                    
                    Text(health.subtitle)
                        .font(.title3)
                        .foregroundColor(.secondary) // Use secondary color for subtitle
                        .frame(maxWidth: .infinity, alignment: .center) // Center the subtitle
                    
                    Divider() // Add a divider for separation
                    
                    VStack(alignment: .center, spacing: 10) { // Align inner VStack center
                        Text("BMI: \(health.amount)")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .center) // Center the BMI text
                        
                        Text("Height: \(bmi.height, specifier: "%.2f") m") // Format height
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .center) // Center the height text
                        
                        Text("Weight: \(bmi.weight, specifier: "%.2f") kg") // Format weight
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .center) // Center the weight text
                    }
                    .padding(.horizontal) // Horizontal padding for inner VStack
                    
                } else {
                    Text("No data available")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center) // Center the no data text
                }
            }
            .padding() // Outer padding for the whole VStack
            .navigationTitle("BMI Details") // Optional: Set the navigation title
            .navigationBarTitleDisplayMode(.inline)
        } // Optional: Inline title display
    }
}
//#Preview {
//    BMIDetailView(health: Health(id: 1, title: "title", subtitle: "subtitle", image: "figure.walk", amount: "100"))
//}

#Preview {
    BMIDetailView(health: Health(id: 1, title: "Calories", subtitle: "Caloric Consumption", image: "figure.walk", amount: "100", color: .orange), bmi: .init(height: 1000, weight: 1000))
        .environmentObject(HealthManager())
}
