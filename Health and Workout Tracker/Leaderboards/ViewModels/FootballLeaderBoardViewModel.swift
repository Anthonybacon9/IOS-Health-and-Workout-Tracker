//
//  FootballLeaderBoardViewModel.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 27/09/2024.
//

import Foundation
import SwiftUI

class LeaderboardViewModel: ObservableObject {
    //@EnvironmentObject var manager: HealthManager
    
    @Published var leaderResult = LeaderboardResult(user: nil, top10: [])
    
    var mockData = [
        LeaderboardFUser(username: "Anthony Bacon", count: 1100),
        LeaderboardFUser(username: "John Doe", count: 1000 ),
        LeaderboardFUser(username: "John Doe", count: 1000 ),
        LeaderboardFUser(username: "John Doe", count: 1000 ),
        LeaderboardFUser(username: "John Doe", count: 1000 ),
        LeaderboardFUser(username: "John Doe", count: 1000 )
    ]
    
    init() {
        Task {
            do {
                try await postMinutesUpdateForUser()
                let result = try await fetchLeaderboards()
                DispatchQueue.main.async {
                    self.leaderResult = result
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    struct LeaderboardResult {
        let user : LeaderboardFUser?
        let top10: [LeaderboardFUser]
    }
    
    func fetchLeaderboards() async throws  -> LeaderboardResult {
        let leaders = try await DatabaseManager.shared.fetchLeaderboards()
        let top10 = Array(leaders.sorted(by: { $0.count > $1.count}).prefix(10))
        let username = UserDefaults.standard.string(forKey: "username")
        
        if let username = username, !top10.contains(where: { $0.username == username}) {
            let user = leaders.first(where: { $0.username == username} )
            return LeaderboardResult(user: user, top10: top10)
        } else {
            return LeaderboardResult(user: nil, top10: top10)
        }
    }
    
    func postMinutesUpdateForUser() async throws {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            throw URLError(.badURL)
        }
        let minutes = try await fetchCurrentWeekMinuteCount()
        try await DatabaseManager.shared.postMinutesUpdateForUser(leader: LeaderboardFUser(username: username, count: Int(minutes)))
    }
    
    private func fetchCurrentWeekMinuteCount() async throws -> Double {
        try await withCheckedThrowingContinuation({ continuation in
            HealthManager.shared.fetchCurrentWeekFootballMinutes { result in
                continuation.resume(with: result)
            }
        })
    }
}
