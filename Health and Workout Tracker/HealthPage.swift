//
//  HealthPage.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 20/09/2024.
//

import SwiftUI

struct HealthPage: View {
    @EnvironmentObject var manager: HealthManager
    var body: some View {
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
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 1)) {
                    ForEach(manager.healthStats.sorted(by: { $0.value.id < $1.value.id}), id: \.key) { item in
                        HealthCard(health: item.value)
                    }
                }
                .padding(.horizontal)
                .scrollTargetLayout()
            }
            .contentMargins(.vertical, 40, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            //.ignoresSafeArea()
            
            Spacer()
            
        }
    }
}

#Preview {
    HealthPage()
        .environmentObject(HealthManager())
}
