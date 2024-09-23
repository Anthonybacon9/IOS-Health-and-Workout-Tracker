//
//  SwiftUIView.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 20/09/2024.
//

import SwiftUI

struct FitnessPage: View {
    @EnvironmentObject var manager: HealthManager

    var body: some View {
        NavigationStack {  // Use NavigationStack to enable navigation
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
                    
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2)) {
                        ForEach(manager.activities.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                            // Wrap ActivityCard with a NavigationLink
                            NavigationLink(destination: ActivityDetailView(activity: item.value)) {
                                ActivityCard(activity: item.value)
                            }.buttonStyle(.plain)
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

struct ActivityDetailView: View {
    var activity: Activity // Assume Activity is the model for the activity

    var body: some View {
        VStack {
            Text(activity.subtitle)
                .font(.subheadline)
                .foregroundStyle(.white)
            Text(activity.amount)
                .font(.system(size: 25))
                .fontWeight(.bold)
                .foregroundStyle(.white)
            // Add more details as per your Activity model
            
            Spacer()
        }
        .padding()
        .navigationTitle(activity.title) // Show the activity name as the navigation title
    }
}

#Preview {
    FitnessPage()
        .environmentObject(HealthManager())
}
