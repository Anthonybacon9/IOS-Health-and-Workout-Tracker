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
    
    private let weeklyLeaderboard = "\(Date().MondayDateFormat())-leaderboard"
    
    private let database = Firestore.firestore()
    
    func fetchLeaderboards() async throws -> [LeaderboardFUser] {
        let snapshot = try await database.collection(weeklyLeaderboard).getDocuments()
        
        return try snapshot.documents.compactMap({ try $0.data(as: LeaderboardFUser.self)})
        
    }
    
    func postMinutesUpdateForUser(leader: LeaderboardFUser) async throws {
        let data = try Firestore.Encoder().encode(leader)
        try await database.collection(weeklyLeaderboard).document(leader.username).setData(data, merge: false)
    }
}
