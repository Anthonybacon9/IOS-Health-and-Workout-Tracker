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
}

class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    @Published var activities: [String : Activity] = [:]
    
    @Published var healthStats: [String : Health] = [:]
    
    @Published var mockActivities: [String : Activity] = [
        "todaySteps" : Activity(id: 0, title: "Today's Steps", subtitle: "Goal: 10,000", image: "figure.walk", amount: "9,098"),
        "todaysCalories" : Activity(id: 1, title: "Today's Calories", subtitle: "Goal: 900", image: "flame.fill", amount: "876")
        ]
    
    init () {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let workout = HKObjectType.workoutType()
        let heartRateType = HKQuantityType(.heartRate)
        
        let healthTypes: Set = [steps, calories, workout, heartRateType]
        
        Task {
            do{
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodaysCalories()
                fetchWeekRunningStats()
                fetchWeekWalkingStats()
                fetchWeekFootballStats()
                fetchWeekHeartRateStats()
            } catch {
                print("error fetching health data")
            }
        }
    }
    
    func fetchTodaySteps() {
        let steps = HKQuantityType(.stepCount)
        _ = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) {_, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching today's step data")
                return
            }
            
            let stepCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 0, title: "Today's Steps", subtitle: "Goal: 10,000", image: "shoeprints.fill", amount: stepCount.formattedString())
            DispatchQueue.main.async {
                self.activities["todaySteps"] = activity
            }
            
            //print(stepCount.formattedString())
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodaysCalories() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) {_, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching today's calorie data")
                return
            }
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 1, title: "Today's Calories", subtitle: "Goal: 900", image: "flame.fill", amount: caloriesBurned.formattedString())
            DispatchQueue.main.async {
                self.activities["todayCalories"] = activity
            }
            
           // print(caloriesBurned.formattedString())
        }
        healthStore.execute(query)
    }
    
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
            let activity = Activity(id: 2, title: "Running", subtitle: "Minutes This Week", image: "figure.run", amount: "\(count)")
            
            DispatchQueue.main.async {
                self.activities["weekRunning"] = activity
            }
        }
        healthStore.execute(query)
    }
    
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
            let activity = Activity(id: 3, title: "Walking", subtitle: "Minutes This Week", image: "figure.walk", amount: "\(count)")
            
            DispatchQueue.main.async {
                self.activities["weekWalking"] = activity
            }
        }
        healthStore.execute(query)
    }
    
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
            let activity = Activity(id: 4, title: "Football", subtitle: "Minutes This Week", image: "figure.soccer", amount: "\(count)")
            
            DispatchQueue.main.async {
                self.activities["weekFootball"] = activity
            }
        }
        healthStore.execute(query)
    }
    
    //HEART RATE
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
            
            let health = Health(id: 3, title: "Heart Rate", subtitle: "Average BPM This Week", image: "heart.fill", amount: String(format: "%.1f", averageHeartRate))
            
            // Update UI on the main thread
            DispatchQueue.main.async {
                self.healthStats["weekHeartRate"] = health
            }
        }
        
        // Execute the query
        healthStore.execute(query)
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

