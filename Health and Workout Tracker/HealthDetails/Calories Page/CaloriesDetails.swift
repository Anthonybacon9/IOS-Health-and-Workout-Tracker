//
//  BMIDetails.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 20/09/2024.
//

import SwiftUI

struct Calories {
    let caloriesEatenToday: String
    let caloriesEatenThisWeek: String
}

struct CaloriesDetailView: View {
    @EnvironmentObject var manager: HealthManager
    var health: Health?
    var calorie: Calories
    
    var body: some View {
            VStack(spacing: 20) { // Add spacing between elements
                if let health = health {
                    Text(health.title)
                        .font(.largeTitle)
                        .fontWeight(.bold) // Emphasize the title
                        .foregroundColor(.primary) // Use primary color for title
                        .padding(.top)

                    Text(health.subtitle)
                        .font(.title3)
                        .foregroundColor(.secondary) // Use secondary color for subtitle

                    Divider() // Add a divider for separation

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Calories Eaten Today: \(calorie.caloriesEatenToday)")
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text("Calories Eaten This Week: \(calorie.caloriesEatenThisWeek)")
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text("Calories Burned Today: \(manager.activities["todayCalories"]?.amount ?? "0.0")")
                            .font(.subheadline)
                            .foregroundColor(.gray) // Slightly lighter for less emphasis
                    }
                    .padding(.horizontal) // Horizontal padding for inner VStack

                } else {
                    Text("No data available")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding() // Outer padding for the whole VStack
            .navigationTitle("Calorie Details") // Optional: Set the navigation title
            .navigationBarTitleDisplayMode(.inline) // Optional: Inline title display
        }
}

#Preview {
    CaloriesDetailView(manager: .init(), health: Health(id: 1, title: "Calories", subtitle: "Caloric Consumption", image: "figure.walk", amount: "100"), calorie: .init(caloriesEatenToday: "1000", caloriesEatenThisWeek: "1000"))
        .environmentObject(HealthManager())
}
