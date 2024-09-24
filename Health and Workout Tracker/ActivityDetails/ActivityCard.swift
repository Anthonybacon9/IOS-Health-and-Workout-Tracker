//
//  SwiftUIView.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 19/09/2024.
//

import SwiftUI

struct Activity {
    let id: Int
    let title: String
    let subtitle: String
    let image: String
    let amount: String
    let color: Color
}

struct ActivityCard: View {
    @State var activity: Activity
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)  // Updated background handling
                .shadow(radius: 10)  // Adding depth
            
            VStack {
                VStack(spacing: 10) { // Added consistent spacing
                    HStack {
                        Text(activity.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    } // Uses adaptive color (dynamic light/dark mode)
                    
                    Divider()
                    
                    Image(systemName: activity.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color(activity.color)) // Light color for icons
                    
                    Text(activity.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(activity.amount)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }
                .padding(20) // Adjusted padding for better spacing
            }
        }
        //.frame(width: 350, height: 180) // Fine-tuned frame size
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5) // Subtle shadow for elevation
        .scrollTransition { content, phase in
            content
                .opacity(phase.isIdentity ? 1.0 : 0.0)
                .scaleEffect(phase.isIdentity ? 1.0 : 0.95)
        }
    }
}

#Preview {
    ActivityCard(activity: Activity(id: 1, title: "Last Workout", subtitle: "Swimming", image: "figure.open.water.swim", amount: "65 Minutes", color: .red))
}
