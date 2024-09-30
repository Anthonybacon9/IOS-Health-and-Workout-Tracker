//
//  SwiftUIView.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 19/09/2024.
//

import SwiftUI

struct Health {
    let id: Int
    let title: String
    let subtitle: String
    let image: String
    let amount: String
    let color: Color
}

struct HealthCard: View {
    @State var health: Health
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)  // Correct background application
                .shadow(radius: 10)  // Adding depth and shadow

            VStack {
                VStack(spacing: 10) {  // Consistent spacing for balance
                    Text(health.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)  // Adaptive for light/dark mode
                    
                    Image(systemName: health.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(health.color)  // Light color for icons
                    
                    Text(health.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)  // Consistent color hierarchy
                    
                    Text(health.amount)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }
                .padding(20)  // Proper padding for spacing and clarity
            }
        }
        //.frame(width: 350, height: 180)  // Adjusted frame size for better layout
        .clipShape(RoundedRectangle(cornerRadius: 15))  // Consistent rounded corners
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)  // Subtle shadow
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
    HealthCard(health: Health(id: 0, title: "TITLE", subtitle: "SUBTITLE", image: "figure.walk", amount: "1", color: .orange))
}
