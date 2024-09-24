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

struct DistanceData {
    let time: Date
    let distance: Double  // Distance at the specific time
}

struct FootballView: View {
    @EnvironmentObject var manager: HealthManager
    var activity: Activity?
    @State var boole = true

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
//                if boole {
                if let football = manager.FootballStats["latestFootball"] {
                    // Title Section
                    Text("Football")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Text("Latest Football Workout")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Divider()
                    
                    //MAKE A SCROLL VIEW FOR MORE CHARTS
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
                                VStack {
                                    Text("Distance Ran Over Time!")
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
                                VStack {
                                    Text("Caolries Burned Over Time")
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
                                
                            }
                        }
                    }.contentMargins(.vertical, 40, for: .scrollContent)
                        .scrollTargetBehavior(.viewAligned)

                    // Stats Section
                    VStack(alignment: .leading, spacing: 15) {
                        StatRowView(label: "Date", value: football.date)
                        StatRowView(label: "Time", value: "\(football.time) - \(football.endTime)")
                        StatRowView(label: "Distance Ran", value: String(format: "%.2f", football.distance) + " km")
                        StatRowView(label: "Calories Burned", value: String(format: "%.0f", football.Kcal) + " kcal")
                        StatRowView(label: "Avg Heart Rate", value: String(format: "%.0f", football.avgHeartRate) + " bpm")
                        StatRowView(label: "Max Heart Rate", value: String(format: "%.0f", football.maxHeartRate) + " bpm")
                        StatRowView(label: "Min Heart Rate", value: String(format: "%.0f", football.minHeartRate) + " bpm")
                        
//                        StatRowView(label: "Date", value: "football.date")
//                        StatRowView(label: "Time", value: " - ")
//                        StatRowView(label: "Distance Ran", value: "football.distance)km")
//                        StatRowView(label: "Calories Burned", value: "football.Kcal) ")
//                        StatRowView(label: "Avg Heart Rate", value: "avgHeartRate bpm")
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
                } else {
                    Text("No football workout data available.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
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
    FootballView(activity: Activity(id: 1, title: "title", subtitle: "subtitle", image: "figure.walk", amount: "100", color: .white))
        .environmentObject(HealthManager())
}
