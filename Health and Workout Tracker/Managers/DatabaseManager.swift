//
//  DatabaseManager.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 26/09/2024.
//

import SwiftUI
import FirebaseFirestore

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() { }
    
    let weeklyLeaderboard = "\(Date().MondayDateFormat())-leaderboard"
    
    let database = Firestore.firestore()
    
    func fetchLeaderboards() async throws {
        let snapshot = try await database.collection(weeklyLeaderboard).getDocuments()
        
        
        
    }
    
    func postStepCountUpdateFor(username: String, count: Int) async throws {
        let leader = LeaderboardFUser(username: username, count: count)
        let data = try Firestore.Encoder().encode(leader)
        try await database.collection(weeklyLeaderboard).document(username).setData(data, merge: false)
    }
}
