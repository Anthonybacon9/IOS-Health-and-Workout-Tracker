//
//  SwiftUIView.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 20/09/2024.
//

import SwiftUI

struct FitnessPage: View {
    @EnvironmentObject var manager: HealthManager
    @State var showFootballPopover = false
    @Binding var authenticated: Bool

    var body: some View {
        NavigationStack {  // Use NavigationStack to enable navigation
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack {
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
                    }
                    
                    
                    
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2)) {
                        ForEach(manager.activities.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                            // Wrap ActivityCard with a NavigationLink
                            if item.value.title == "Football" {
                                ActivityCard(activity: item.value, authenticated: $authenticated, cardType: "football")
                                    .onTapGesture {
                                        showFootballPopover.toggle() // Toggle the popover when the card is tapped
                                    }
                                    .popover(isPresented: $showFootballPopover) {
                                        FootballView(activity: item.value)
                                            .frame(width: 300, height: 400) // Customize the size of the popover
                                    }
                                    .buttonStyle(PlainButtonStyle())
                            } else {
                                NavigationLink(destination: ActivityDetailView(activity: item.value)) {
                                    ActivityCard(activity: item.value, authenticated: $authenticated, cardType: "")
                                }.buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .scrollTargetLayout()
                    
//                    Button {
//                        manager.refreshData()
//                    } label: {
//                        Text("Refresh")
//                    }

                }
                .contentMargins(.vertical, 40, for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)
                .refreshable {
                    await manager.refreshData() // Call the refresh method when pulled
                }
                
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
    FitnessPage(authenticated: .constant(true))
        .environmentObject(HealthManager())
}
