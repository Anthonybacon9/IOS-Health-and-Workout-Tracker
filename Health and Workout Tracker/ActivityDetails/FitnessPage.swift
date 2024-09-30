import SwiftUI

struct FitnessPage: View {
    @EnvironmentObject var manager: HealthManager
    @State var showFootballPopover = false
    @State var showWalkingPopover = false
    @Binding var authenticated: Bool
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Text(getFormattedDate())
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 25)
                            .foregroundStyle(.orange)
                        Spacer()
                        Text(getFormattedTime())
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 25)
                            .foregroundStyle(.orange)
                    }
                    .scrollTransition { content, phase in
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
                    
                    // Favorites Section
                    if manager.activities.contains(where: { $0.value.favorite }) {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 1)) {
                            ForEach(manager.activities.filter { $0.value.favorite }, id: \.key) { item in
                                if item.value.title == "Football" {
                                    ActivityCard(activity: item.value, authenticated: $authenticated, cardType: "football")
                                        .onTapGesture {
                                            showFootballPopover.toggle()
                                        }
                                        .contextMenu {
                                            Button(item.value.favorite ? "Unfavourite" : "Favourite") {
                                                toggleFavorite(for: item.key)
                                            }
                                        }
                                        .popover(isPresented: $showFootballPopover) {
                                            FootballView(activity: item.value)
                                                .frame(width: 300, height: 400)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                } else if item.value.title == "Walking" {
                                    ActivityCard(activity: item.value, authenticated: $authenticated, cardType: "Walking")
                                        .onTapGesture {
                                            showWalkingPopover.toggle()
                                        }
                                        .contextMenu {
                                            Button(item.value.favorite ? "Unfavourite" : "Favourite") {
                                                toggleFavorite(for: item.key)
                                            }
                                        }
                                        .popover(isPresented: $showWalkingPopover) {
                                            WalkingView(activity: item.value)
                                                .frame(width: 300, height: 400)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    
                    // All Activities Section (excluding favorites)
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2)) {
                        ForEach(manager.activities.filter { !$0.value.favorite }.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                            if item.value.title == "Football" {
                                ActivityCard(activity: item.value, authenticated: $authenticated, cardType: "football")
                                    .onTapGesture {
                                        showFootballPopover.toggle()
                                    }
                                    .contextMenu {
                                        Button(item.value.favorite ? "Unfavourite" : "Favourite") {
                                            toggleFavorite(for: item.key)
                                        }
                                    }
                                    .popover(isPresented: $showFootballPopover) {
                                        FootballView(activity: item.value)
                                            .frame(width: 300, height: 400)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                            } else if item.value.title == "Walking" {
                                ActivityCard(activity: item.value, authenticated: $authenticated, cardType: "Walking")
                                    .onTapGesture {
                                        showWalkingPopover.toggle()
                                    }
                                    .contextMenu {
                                        Button(item.value.favorite ? "Unfavourite" : "Favourite") {
                                            toggleFavorite(for: item.key)
                                        }
                                    }
                                    .popover(isPresented: $showWalkingPopover) {
                                        WalkingView(activity: item.value)
                                            .frame(width: 300, height: 400)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                            } else {
                                NavigationLink(destination: ActivityDetailView(activity: item.value)) {
                                    ActivityCard(activity: item.value, authenticated: $authenticated, cardType: "")
                                        .contextMenu {
                                            Button(item.value.favorite ? "Unfavourite" : "Favourite") {
                                                toggleFavorite(for: item.key)
                                            }
                                        }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .contentMargins(.vertical, 10, for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)
                .refreshable {
                    await manager.refreshData() // Call the refresh method when pulled
                }
            }
            .padding(.bottom)
            Spacer()
        }
    }
    
    private func refreshHealthData() {
            Task {
                await manager.refreshData() // Call refreshData when button is pressed
            }
        }
    private func toggleFavorite(for key: String) {
        if let index = manager.activities.firstIndex(where: { $0.key == key }) {
            var updatedActivity = manager.activities[index].value
            updatedActivity.favorite.toggle() // Toggle the favorite status
            manager.activities[key] = updatedActivity // Update the activity using the key
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
