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
}

struct HealthCard: View {
    @State var health: Health
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .background(.ultraThinMaterial)
            VStack {
                HStack {
                    VStack {
                        Text("\(health.title) \(Image(systemName: health.image))")
                            //.font(.headline)
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Text(health.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                        Text(health.amount)
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }.padding(10)
                }
            }
        }/*.frame(width: 380, height: 190)*/
            .clipShape(RoundedRectangle(cornerRadius: 15))
//            .scrollTransition { content, phase in
//                content
//                    .opacity(phase.isIdentity ? 1.0 : 0.0)
//                    .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3, y: phase.isIdentity ? 1.0 : 0.3)
//            }
    }
}

#Preview {
    HealthCard(health: Health(id: 0, title: "TITLE", subtitle: "SUBTITLE", image: "figure.walk", amount: "1"))
}
