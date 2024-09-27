//
//  HealthManager.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 19/09/2024.
//

import SwiftUI
import HealthKit
import Foundation

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    static var startOfWeek: Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2 //monday
        
        return calendar.date(from: components)!
    }
    
    func fetchPreviousMonday() -> Date? {
        let calendar = Calendar.current
        
        let weekday = calendar.component(.weekday, from: self)
        
        let daysToSubtract = (weekday + 5) % 7
        
        var dateComponents = DateComponents()
        dateComponents.day = -daysToSubtract
        
        return calendar.date(byAdding: dateComponents, to: self) ?? Date()
    }
    
    func MondayDateFormat() -> String {
        let monday = self.fetchPreviousMonday()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: monday!)
    }
}

class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    @Published var activities: [String : Activity] = [:]
    
    @Published var healthStats: [String : Health] = [:]
    
    @Published var BMIStats: [String : BMI] = [:]
    
    @Published var CaloriesStats: [String : Calories] = [:]
    
    @Published var FootballStats: [String : Football] = [:]
    
    @Published var footballWorkouts: [Football] = []
//
//    @Published var MockFootballStats: [String : Football] = [id:]
    
    @Published var height: Double!
    
    @Published var navigateToBMIDetail: Bool = false // New property to trigger navigation
    @Published var selectedBMI: Health? // Holds the BMI data for the detail view
    
//    @Published var mockActivities: [String : Activity] = [
//        "todaySteps" : Activity(id: 0, title: "Today's Steps", subtitle: "Goal: 10,000", image: "figure.walk", amount: "9,098"),
//        "todaysCalories" : Activity(id: 1, title: "Today's Calories", subtitle: "Goal: 900", image: "flame.fill", amount: "876")
//        ]
    
    init () {
        let healthTypes: Set = [
                    HKQuantityType(.stepCount),
                    HKQuantityType(.activeEnergyBurned),
                    HKObjectType.workoutType(),
                    HKQuantityType(.heartRate),
                    HKQuantityType.quantityType(forIdentifier: .bodyMass)!,
                    HKQuantityType.quantityType(forIdentifier: .height)!,
                    HKQuantityType(.dietaryEnergyConsumed),
                    HKQuantityType.quantityType(forIdentifier: .vo2Max)!
                ]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                await refreshData() // Call refreshData here
            } catch {
                print("Error requesting HealthKit authorization: \(error)")
            }
        }
    }
    
    func refreshData() async {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.fetchTodaySteps() }
                group.addTask { await self.fetchWeekFootballStats() }
                group.addTask { await self.fetchTodaysCalories() }
                group.addTask { await self.fetchCaloriesData() }
                group.addTask { await self.fetchWeekRunningStats() }
                group.addTask { await self.fetchWeekWalkingStats() }
                group.addTask { await self.fetchWeekHeartRateStats() }
                group.addTask { await self.fetchBMIStats() }
                group.addTask { await self.fetchLatestFootballWorkout() }
                group.addTask { await self.fetchFootballWorkouts() }
            }
        }
    
    // MARK: TODAYS STEPS
    func fetchTodaySteps() {
        let steps = HKQuantityType(.stepCount)
        _ = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: .now)
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) {_, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching today's step data")
                return
            }
            
            let stepCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 0, title: "Steps", subtitle: "Today", image: "shoeprints.fill", amount: stepCount.formattedString(), color: .blue)
            DispatchQueue.main.async {
                self.activities["todaySteps"] = activity
                //print(stepCount)
            }
            
            //print(stepCount.formattedString())
        }
        
        healthStore.execute(query)
    }
    
    // MARK: TODAYS CALORIES
    func fetchTodaysCalories() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) {_, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching today's calorie data")
                return
            }
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 2, title: "Today's Calories", subtitle: "Goal: 900", image: "flame.fill", amount: caloriesBurned.formattedString(), color: .orange)
            DispatchQueue.main.async {
                self.activities["todayCalories"] = activity
            }
            
           // print(caloriesBurned.formattedString())
        }
        healthStore.execute(query)
    }
    
    // MARK: TODAYS CALORIES EATEN
    func fetchCaloriesData() {
        let calorieType = HKQuantityType(.dietaryEnergyConsumed)
        
        // Fetch today's calories
        let todayPredicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let todayQuery = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: todayPredicate) { _, result, error in
            guard let todayQuantity = result?.sumQuantity(), error == nil else {
                print("Error fetching today's calorie data")
                return
            }
            
            let caloriesEatenToday = todayQuantity.doubleValue(for: .kilocalorie())
            let healthToday = Health(id: 1, title: "Calories Eaten Today", subtitle: "Goal: 2000", image: "fork.knife", amount: caloriesEatenToday.formattedString())
            let calories = Calories(caloriesEatenToday: caloriesEatenToday.formattedString(), caloriesEatenThisWeek: "0.0") // Default for this week
            
            // Update the health stats for today
            DispatchQueue.main.async {
                self.CaloriesStats["todayCaloriesEaten"] = calories
                self.healthStats["calories"] = healthToday
            }
            
            // Now fetch this week's calories
            let weekPredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
            let weekQuery = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: weekPredicate) { _, result, error in
                guard let weekQuantity = result?.sumQuantity(), error == nil else {
                    print("Error fetching this week's calorie data")
                    return
                }
                
                let caloriesEatenThisWeek = weekQuantity.doubleValue(for: .kilocalorie()).formattedString()
                
                // Update the calories object with this week's data
                DispatchQueue.main.async {
                    let updatedCalories = Calories(caloriesEatenToday: caloriesEatenToday.formattedString(), caloriesEatenThisWeek: caloriesEatenThisWeek)
                    self.CaloriesStats["calories"] = updatedCalories // Store the updated calories
                }
            }
            
            // Execute the weekly query
            self.healthStore.execute(weekQuery)
        }
        
        // Execute the daily query
        healthStore.execute(todayQuery)
    }
    
    // MARK: WEEK RUNNING STATS
    func fetchWeekRunningStats() {
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: 20, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print("Error fetching week running data")
                return
            }
            
            var count: Int = 0
            for workout in workouts {
                let duration = Int(workout.duration)/60
                count += duration
            }
            let activity = Activity(id: 2, title: "Running", subtitle: "Minutes This Week", image: "figure.run", amount: "\(count)", color: .green)
            
            DispatchQueue.main.async {
                self.activities["weekRunning"] = activity
            }
        }
        healthStore.execute(query)
    }
    
    // MARK: WEEK WALKING STATS
    func fetchWeekWalkingStats() {
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .walking)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: 20, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print("Error fetching week running data")
                return
            }
            
            var count: Int = 0
            for workout in workouts {
                let duration = Int(workout.duration)/60
                count += duration
            }
            let activity = Activity(id: 1, title: "Walking", subtitle: "Minutes This Week", image: "figure.walk", amount: "\(count)", color: .yellow)
            
            DispatchQueue.main.async {
                self.activities["weekWalking"] = activity
            }
        }
        healthStore.execute(query)
    }
    
    // MARK: WEEK FOOTBALL STATS
    func fetchWeekFootballStats() {
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .soccer)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: 20, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print("Error fetching week running data")
                return
            }
            
            var count: Int = 0
            for workout in workouts {
                let duration = Int(workout.duration)/60
                count += duration
            }
            let activity = Activity(id: 4, title: "Football", subtitle: "Minutes This Week", image: "figure.soccer", amount: "\(count)", color: .red)
            
            DispatchQueue.main.async {
                self.activities["weekFootball"] = activity
            }
        }
        healthStore.execute(query)
    }
    
    // MARK: LATEST FOOTBALL WORKOUT
    func fetchLatestFootballWorkout() {
        let workoutType = HKSampleType.workoutType()
        
        // Set up the date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        let timeFormatter = DateFormatter()
        //timeFormatter.dateStyle = .medium
        timeFormatter.timeStyle = .short
        
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .soccer)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: workoutType, predicate: workoutPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let workout = samples?.first as? HKWorkout, error == nil else {
                print("Error fetching latest football workout data")
                return
            }
            
            let duration = Int(workout.duration) / 60
            let distance = workout.totalDistance?.doubleValue(for: .meterUnit(with: .kilo)) ?? 0.0
            let caloriesBurned = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0.0
            let formattedDate = dateFormatter.string(from: workout.startDate)
            let formattedTime = timeFormatter.string(from: workout.startDate)
            let formattedEndTime = timeFormatter.string(from: workout.endDate)
            
            var _: Double = 0.0
            var _: Double = 0.0
            var _: Double = 0.0
            
            // Fetch heart rate data
            let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
            let heartRatePredicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate)
            
            let heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: heartRatePredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
                guard let heartRateSamples = samples as? [HKQuantitySample], error == nil else {
                    print("Error fetching heart rate data")
                    return
                }
                
                var heartRates: [HeartRate] = heartRateSamples.map {
                    HeartRate(time: $0.startDate, bpm: $0.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute())))
                }
                
                let avgHeartRate = heartRates.map(\.bpm).reduce(0, +) / Double(heartRates.count)
                let maxHeartRate = heartRates.map(\.bpm).max() ?? 0.0
                let minHeartRate = heartRates.map(\.bpm).min() ?? 0.0
                
                
                // Get VO2 Max value
                //vo2Max = vo2MaxSample.quantity.doubleValue(for: HKUnit(from: "ml/kg*min"))
                
                // Update the football data with VO2 max
                let football = Football(
                    id: 4,
                    title: "Latest Football Workout",
                    distance: distance,
                    Kcal: caloriesBurned,
                    date: formattedDate,
                    time: formattedTime,
                    endTime: formattedEndTime,
                    avgHeartRate: avgHeartRate,
                    maxHeartRate: maxHeartRate,
                    minHeartRate: minHeartRate,
                    heartRates: heartRates
                )
                
                // Update UI
                DispatchQueue.main.async {
                    self.FootballStats["latestFootball"] = football
                }
                
                
                //self.healthStore.execute(vo2MaxQuery)
            }
            
            self.healthStore.execute(heartRateQuery)
            
            // Create the activity for the basic workout data
//            let activity = Activity(
//                id: 4,
//                title: "Latest Football Workout",
//                subtitle: "Duration: \(duration) min",
//                image: "figure.soccer",
//                amount: "Distance: \(distance) km\nCalories: \(caloriesBurned) kcal"
//            )
            
            // Update UI for the basic data
            //            DispatchQueue.main.async {
            //                self.activities["latestFootball"] = activity
            //            }
        }
        
        healthStore.execute(query)
    }
    
    // MARK: ALL FOOTBALL WORKOUTS
    func fetchFootballWorkouts() {
        let workoutType = HKSampleType.workoutType()
        
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .soccer)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: workoutType, predicate: workoutPredicate, limit: 0, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let workouts = samples as? [HKWorkout], error == nil else {
                print("Error fetching football workouts: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            for workout in workouts {
                let duration = Int(workout.duration) / 60
                let distance = workout.totalDistance?.doubleValue(for: .meterUnit(with: .kilo)) ?? 0.0
                let caloriesBurned = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0.0
                let startDate = workout.startDate
                let endDate = workout.endDate

                var heartRates: [HeartRate] = []

                // Fetch heart rate data for the workout period
                let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
                let heartRatePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)

                let heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: heartRatePredicate, limit: 0, sortDescriptors: nil) { _, heartRateSamples, error in
                    guard let heartRateSamples = heartRateSamples as? [HKQuantitySample], error == nil else {
                        print("Error fetching heart rate data: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }

                    // Process heart rate samples
                    for sample in heartRateSamples {
                        let bpm = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                        let time = sample.startDate
                        heartRates.append(HeartRate(time: time, bpm: bpm))
                    }

                    // Calculate average, max, and min heart rates
                    let avgHeartRate = heartRates.map { $0.bpm }.reduce(0, +) / Double(heartRates.count)
                    let maxHeartRate = heartRates.map { $0.bpm }.max() ?? 0
                    let minHeartRate = heartRates.map { $0.bpm }.min() ?? 0

                    // Create the Football object with workout and heart rate data
                    let football = Football(
                        id: Int(workout.uuid.uuidString.hashValue),  // Use hash of the UUID as an ID
                        title: "Football Workout",
                        distance: distance,
                        Kcal: caloriesBurned,
                        date: DateFormatter.localizedString(from: startDate, dateStyle: .medium, timeStyle: .none),
                        time: DateFormatter.localizedString(from: startDate, dateStyle: .none, timeStyle: .short),
                        endTime: DateFormatter.localizedString(from: endDate, dateStyle: .none, timeStyle: .short),
                        avgHeartRate: avgHeartRate,
                        maxHeartRate: maxHeartRate,
                        minHeartRate: minHeartRate,
                        heartRates: heartRates
                    )

                    // Update the workouts list (assuming you have a way to store the workouts)
                    DispatchQueue.main.async {
                        self.footballWorkouts.append(football)
                    }
                }
                
                self.healthStore.execute(heartRateQuery)
            }
        }
        
        healthStore.execute(query)
    }
    
    // MARK: HEART RATE
    func fetchWeekHeartRateStats() {
        let heartRateType = HKQuantityType(.heartRate)
        // Predicate for the last week (start of week to current date)
        let timePredicate = HKQuery.predicateForSamples(withStart: Date.startOfWeek, end: Date())
        
        // Create the query
        let query = HKSampleQuery(sampleType: heartRateType, predicate: timePredicate, limit: 0, sortDescriptors: nil) { _, samples, error in
            guard let heartRateSamples = samples as? [HKQuantitySample], error == nil else {
                print("Error fetching week heart rate data")
                return
            }
            
            // Accumulate heart rate data
            var totalHeartRate = 0.0
            var count = 0
            
            for sample in heartRateSamples {
                // Convert heart rate to beats per minute (BPM)
                let heartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                totalHeartRate += heartRate
                count += 1
            }
            
            // Calculate the average heart rate if there were any samples
            let averageHeartRate = count > 0 ? totalHeartRate / Double(count) : 0
            
            let health = Health(id: 0, title: "Heart Rate", subtitle: "Average BPM This Week", image: "heart.fill", amount: String(format: "%.1f", averageHeartRate))
            
            // Update UI on the main thread
            DispatchQueue.main.async {
                self.healthStats["weekHeartRate"] = health
            }
        }
        
        // Execute the query
        healthStore.execute(query)
    }
    
    // MARK: BMI STATS
    func fetchBMIStats() {
        let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
        let heightType = HKQuantityType.quantityType(forIdentifier: .height)!
        let dispatchGroup = DispatchGroup()
        
        var weightInKg: Double?
        var heightInMeters: Double?
        
        // Fetch the latest weight sample
        dispatchGroup.enter()
        let weightQuery = HKSampleQuery(sampleType: weightType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, error in
            if let sample = samples?.first as? HKQuantitySample {
                weightInKg = sample.quantity.doubleValue(for: .gramUnit(with: .kilo))
            }
            dispatchGroup.leave()
        }
        
        // Fetch the latest height sample
        dispatchGroup.enter()
        let heightQuery = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, error in
            if let sample = samples?.first as? HKQuantitySample {
                heightInMeters = sample.quantity.doubleValue(for: .meter())
            }
            dispatchGroup.leave()
        }
        
        // Execute the queries
        healthStore.execute(weightQuery)
        healthStore.execute(heightQuery)
        
        // Once both queries have completed, calculate and update the BMI
        dispatchGroup.notify(queue: .main) {
            guard let weight = weightInKg, let height = heightInMeters else {
                print("Error fetching weight or height data")
                return
            }
            
            // Calculate BMI
            let bmi1 = weight / (height * height)
            let formattedBMI = String(format: "%.2f", bmi1)
            
            // Create an Activity instance to display the BMI
            let health = Health(id: 1, title: "BMI", subtitle: "Body Mass Index", image: "heart.text.square", amount: formattedBMI)
            let bmi = BMI(height: height, weight: weight)
            
            // Update the activity in the main thread
            DispatchQueue.main.async {
                self.healthStats["bmi"] = health
                self.BMIStats["bmi"] = bmi
                self.selectedBMI = health // Set the selected BMI for detail view
                self.height = height
            }
        }
    }
    
    
}

extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

