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
    @State var showCalPopover = false
    @State  var showBMIPopover = false
    
    var body: some View {// Use NavigationStack to enable navigation
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
                    Divider()
                        .padding(.vertical, 5)
                        .scrollTransition { content, phase in
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
                                
                                HealthCard(health: item.value)
                                    .onTapGesture {
                                        showBMIPopover.toggle() // Toggle the popover when the card is tapped
                                    }
                                    .popover(isPresented: $showBMIPopover) {
                                        BMIDetailView(health: item.value, bmi: BMI(height: height, weight: weight))
                                            .frame(width: 300, height: 400) // Customize the size of the popover
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                
                            } else if item.value.title == "Calories Eaten Today" {
                                // Access the calorie data from the manager
                                let amountToday = manager.CaloriesStats["calories"]?.caloriesEatenToday ?? "0.0"
                                let amountThisWeek = manager.CaloriesStats["calories"]?.caloriesEatenThisWeek ?? "0.0"
                                
                                // Use state to control the popover visibilit
                                
                                HealthCard(health: item.value)
                                    .onTapGesture {
                                        showCalPopover.toggle() // Toggle the popover when the card is tapped
                                    }
                                    .popover(isPresented: $showCalPopover) {
                                        CaloriesDetailView(health: item.value, calorie: Calories(caloriesEatenToday: amountToday, caloriesEatenThisWeek: amountThisWeek))
                                            .frame(width: 300, height: 400) // Customize the size of the popover
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
                .contentMargins(.vertical, 10, for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)
                
                Spacer()
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
