//
//  Health_and_Workout_TrackerApp.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 18/09/2024.
//

import SwiftUI

@main
struct Health_and_Workout_TrackerApp: App {
    @StateObject var manager = HealthManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
        }
    }
}
