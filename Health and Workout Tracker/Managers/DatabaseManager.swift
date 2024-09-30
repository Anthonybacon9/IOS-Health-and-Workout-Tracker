//
//  DatabaseManager.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 26/09/2024.
//
import FirebaseFirestore
import CryptoKit // For password hashing

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() { }
    
    private let weeklyFootballLeaderboard = "Football-\(Date().MondayDateFormat())-leaderboard"
    private let weeklyWalkingLeaderboard = "Walking-\(Date().MondayDateFormat())-leaderboard"
    
    private let database = Firestore.firestore()

    // Fetch leaderboards
    func fetchFootballLeaderboards() async throws -> [LeaderboardFUser] {
        let snapshot = try await database.collection(weeklyFootballLeaderboard).getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: LeaderboardFUser.self) }
    }
    
    func fetchWalkingLeaderboards() async throws -> [LeaderboardFUser] {
        let snapshot = try await database.collection(weeklyWalkingLeaderboard).getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: LeaderboardFUser.self) }
    }
    
    // Update leaderboard for a user
    func postMinutesUpdateForUser(leader: LeaderboardFUser) async throws {
        let data = try Firestore.Encoder().encode(leader)
        try await database.collection(weeklyFootballLeaderboard).document(leader.username).setData(data, merge: false)
    }
    
    func postWalkingUpdateForUser(leader: LeaderboardFUser) async throws {
        let data = try Firestore.Encoder().encode(leader)
        try await database.collection(weeklyWalkingLeaderboard).document(leader.username).setData(data, merge: false)
    }

    // Hashing function for passwords
    private func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    // Register new user with hashed password
    func registerUser(username: String, password: String, email: String) async throws {
        let hashedPassword = hashPassword(password)
        let userData: [String: Any] = [
            "username": username,
            "password": hashedPassword, // store the hashed password
            "email": email
        ]
        try await database.collection("users").document(username).setData(userData)
    }
    
    // Fetch user profile
    func fetchUserProfile(username: String) async throws -> UserProfiles? {
        let document = try await database.collection("users").document(username).getDocument()
        return try document.data(as: UserProfiles.self)
    }
    
    func fetchPublicUsername(uid: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let username = document.get("publicUsername") as? String
                completion(username)
            } else {
                completion(nil)
            }
        }
    }
}

// Define your UserProfile model
struct UserProfiles: Codable {
    let username: String
    let email: String
    // Add other profile-related fields here
}
