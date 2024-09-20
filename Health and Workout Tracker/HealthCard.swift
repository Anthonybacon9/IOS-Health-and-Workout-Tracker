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
}

struct ActivityCard: View {
    @State var activity: Activity
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .background(.ultraThinMaterial)
            VStack {
                HStack {
                    VStack {
//                        Image(systemName: activity.image)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 50, height: 50)
                        Text("\(activity.title) \(Image(systemName: activity.image))")
                            //.font(.headline)
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Text(activity.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                        Text(activity.amount)
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }.padding(10)
                }
            }
        }/*.frame(width: 380, height: 190)*/
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .scrollTransition { content, phase in
                content
                    .opacity(phase.isIdentity ? 1.0 : 0.0)
                    .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3, y: phase.isIdentity ? 1.0 : 0.3)
            }
    }
}

#Preview {
    ActivityCard(activity: Activity(id: 1, title: "Last Workout", subtitle: "Swimming", image: "figure.open.water.swim", amount: "65 Minutes"))
}
