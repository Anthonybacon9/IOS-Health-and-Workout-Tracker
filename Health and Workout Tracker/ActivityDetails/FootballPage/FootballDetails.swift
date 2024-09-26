import SwiftUI
import Charts

struct Football {
    let id: Int
    let title: String
    let distance: Double
    let Kcal: Double
    let date: String
    let time: String
    let endTime : String
    let avgHeartRate: Double
    let maxHeartRate: Double
    let minHeartRate: Double
    let heartRates: [HeartRate]
}

struct HeartRate {
    let time: Date
    let bpm: Double
}

struct FootballView: View {
    @EnvironmentObject var manager: HealthManager
    var activity: Activity?
    @State private var currentIndex: Int = 0  // Track the current workout index
    
    var body: some View {
        ZStack {
            // Background soccer image with opacity for subtle effect
            GeometryReader { geometry in
                Image(systemName: "soccerball")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.05)
            }
            .ignoresSafeArea()

            VStack(spacing: 20) {
                if manager.footballWorkouts.indices.contains(currentIndex) {
                    let football = manager.footballWorkouts[currentIndex]
                    
                    // Title Section
                    Text("Football")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .center)

                    HStack {
                        // Chevron right button for next workout
                        Button {
                            if currentIndex < manager.footballWorkouts.count - 1 {
                                currentIndex += 1
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .disabled(currentIndex == manager.footballWorkouts.count - 1)  // Disable if at the last workout

                        Text(football.date)
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
                        if !football.heartRates.isEmpty {
                            HStack {
                                VStack {
                                    Text("Heart Rate Over Time")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                    
                                    Chart(football.heartRates, id: \.time) { rate in
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
                        StatRowView(label: "Time", value: "\(football.time) - \(football.endTime)")
                        StatRowView(label: "Distance Ran", value: String(format: "%.2f", football.distance) + " km")
                        StatRowView(label: "Calories Burned", value: String(format: "%.0f", football.Kcal) + " kcal")
                        StatRowView(label: "Avg Heart Rate", value: String(format: "%.0f", football.avgHeartRate) + " bpm")
                        StatRowView(label: "Max Heart Rate", value: String(format: "%.0f", football.maxHeartRate) + " bpm")
                        StatRowView(label: "Min Heart Rate", value: String(format: "%.0f", football.minHeartRate) + " bpm")
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
                    
                    Text("Football")
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

// Reusable StatRowView for cleaner code
struct StatRowView: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    FootballView()
        .environmentObject(HealthManager())  // Provide HealthManager to the view
}
