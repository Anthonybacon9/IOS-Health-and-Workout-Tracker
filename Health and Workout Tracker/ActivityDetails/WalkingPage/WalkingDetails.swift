import SwiftUI
import Charts

struct Walking: Identifiable {
    var id: Int
    var title: String
    var distance: Double
    var Kcal: Double
    var date: String
    var time: String
    var endTime: String
    var avgHeartRate: Double
    var maxHeartRate: Double
    var minHeartRate: Double
    var heartRates: [HeartRate]
    var caloriesEaten: Double
    var startDate: Date  // Add startDate property here
}


struct WalkingView: View {
    @EnvironmentObject var manager: HealthManager
    var activity: Activity?
    @State private var currentIndex: Int = 0  // Track the current workout index
    
    var body: some View {
        ZStack {
            // Background soccer image with opacity for subtle effect
            GeometryReader { geometry in
                Image(systemName: "figure.walk")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.05)
            }
            .ignoresSafeArea()

            VStack(spacing: 20) {
                if manager.walkingWorkouts.indices.contains(currentIndex) {
                    let walking = manager.walkingWorkouts[currentIndex]
                    
                    // Title Section
                    Text("Walking")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .center)

                    HStack {
                        // Chevron right button for next workout
                        Button {
                            if currentIndex < manager.walkingWorkouts.count - 1 {
                                currentIndex += 1
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .disabled(currentIndex == manager.walkingWorkouts.count - 1)  // Disable if at the last workout

                        Text(walking.date)
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        // Chevron left button for previous workout
                        Button {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                        .disabled(currentIndex == 0)  // Disable if at the first workout
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Divider()

                    // Scroll view for charts
                    ScrollView(.horizontal, showsIndicators: false) {
                        if !walking.heartRates.isEmpty {
                            HStack {
                                VStack {
                                    Text("Heart Rate Over Time")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                    
                                    Chart(walking.heartRates, id: \.time) { rate in
                                        LineMark(
                                            x: .value("Time", rate.time),
                                            y: .value("BPM", rate.bpm)
                                        )
                                        .foregroundStyle(Color.red)
                                        .interpolationMethod(.catmullRom)
                                    }
                                    .frame(width: 250, height: 200)
                                    .padding(.horizontal)
                                    .scrollTargetLayout()
                                }
                                
                                // Add more charts here as needed
                            }
                        }
                    }
                    .contentMargins(.vertical, 40, for: .scrollContent)
                    .scrollTargetBehavior(.viewAligned)
                    
                    Divider()

                    // Stats Section
                    VStack(alignment: .leading, spacing: 15) {
                        StatRowView(label: "Time", value: "\(walking.time) - \(walking.endTime)")
                        StatRowView(label: "Distance Ran", value: String(format: "%.2f", walking.distance) + " km")
                        StatRowView(label: "Calories Burned", value: String(format: "%.0f", walking.Kcal) + " kcal")
                        StatRowView(label: "Calories this day", value: String(format: "%.0f", walking.caloriesEaten) + " Kcal")
                        StatRowView(label: "Avg Heart Rate", value: String(format: "%.0f", walking.avgHeartRate) + " bpm")
                        StatRowView(label: "Max Heart Rate", value: String(format: "%.0f", walking.maxHeartRate) + " bpm")
                        StatRowView(label: "Min Heart Rate", value: String(format: "%.0f", walking.minHeartRate) + " bpm")
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
                    
                    
                } else {
//                    Text("No football workout data available.")
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("Walking")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .center)

                    HStack {
                        // Chevron right button for next workout

                        Text("date")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        // Chevron left button for previous workout
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Divider()

                    // Scroll view for charts
                    ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                VStack {
                                    Text("Heart Rate Over Time")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                    Rectangle()
                                        .fill(Color.primary)
                                        .frame(width: 250, height: 200)
                                        .padding(.horizontal)
                                        .scrollTargetLayout()
                                }
                                
                                // Add more charts here as needed
                            }
                    
                    }
                    .contentMargins(.vertical, 20, for: .scrollContent)
                    .scrollTargetBehavior(.viewAligned)
                    
                    Divider()

                    // Stats Section
                    VStack(alignment: .leading, spacing: 15) {
                        StatRowView(label: "Time", value: "00:00")
                        StatRowView(label: "Distance Ran", value: "km")
                        StatRowView(label: "Calories Burned", value: "kcal")
                        StatRowView(label: "Avg Heart Rate", value: " bpm")
                        StatRowView(label: "Max Heart Rate", value:" bpm")
                        StatRowView(label: "Min Heart Rate", value: " bpm")
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Football Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    WalkingView()
        .environmentObject(HealthManager())  // Provide HealthManager to the view
}
