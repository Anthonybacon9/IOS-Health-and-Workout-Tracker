//
//  HealthPage.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 20/09/2024.
//

import SwiftUI

struct HealthPage: View {
    @EnvironmentObject var manager: HealthManager
    @State private var isBMIDetailActive = false
    
    var body: some View {
        NavigationStack { // Use NavigationStack to enable navigation
            VStack {
                ScrollView(showsIndicators: false) {
                    HStack {
                        Text(getFormattedDate())
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .foregroundStyle(.orange)
                        Spacer()
                        Text(getFormattedTime())
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal)
                            .foregroundStyle(.orange)
                    }.scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1.0 : 0.0)
                            .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3, y: phase.isIdentity ? 1.0 : 0.3)
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 1)) {
                        ForEach(manager.healthStats.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                            // Wrap HealthCard with a NavigationLink
                            if item.value.title == "BMI" {
                                let height = manager.BMIStats["bmi"]?.height ?? 0.0 // Provide a fallback value
                                let weight = manager.BMIStats["bmi"]?.weight ?? 0.0 // Provide a fallback value
                                
                                NavigationLink(destination: BMIDetailView(health: item.value, bmi: BMI(height: height, weight: weight))) {
                                    HealthCard(health: item.value)
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                NavigationLink(destination: HealthDetailView(health: item.value)) {
                                    HealthCard(health: item.value)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .scrollTargetLayout()
                }
                .contentMargins(.vertical, 40, for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)
                
                Spacer()
            }
        }
    }
}

struct HealthDetailView: View {
    var health: Health // Assume HealthStat is the model for the health stats

    var body: some View {
        VStack {
            Text(health.subtitle)
                .font(.subheadline)
                .foregroundStyle(.white)
            Text(health.amount)
                .font(.system(size: 25))
                .fontWeight(.bold)
                .foregroundStyle(.white)
            Spacer()
        }
        .padding()
        .navigationTitle(health.title) // Show the activity name as the navigation title
    }
}

#Preview {
    HealthPage()
        .environmentObject(HealthManager())
}
