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
        VStack {
            if let health = health {
                Text(health.title)
                    .font(.largeTitle)
                Text(health.subtitle)
                    .font(.subheadline)
                Text("BMI: \(health.amount)")
                    .font(.headline)
                Text("Height: \(bmi.height) m")
                    .font(.headline)
                Text("Height: \(bmi.weight) m")
                    .font(.headline)
            } else {
                Text("No data available")
            }
        }
        .padding()
    }
}

//#Preview {
//    BMIDetailView(health: Health(id: 1, title: "title", subtitle: "subtitle", image: "figure.walk", amount: "100"))
//}
