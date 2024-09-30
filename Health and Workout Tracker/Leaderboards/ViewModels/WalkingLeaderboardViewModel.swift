//
//  FootballLeaderBoardViewModel.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 27/09/2024.
//

import Foundation
import SwiftUI

class WalkingLeaderboardViewModel: ObservableObject {
    //@EnvironmentObject var manager: HealthManager
    
    @Published var walkingLeaderResult = walkingLeaderboardResult(user: nil, top10: [])
    
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
                try await postWalkingUpdateForUser()
                let result = try await fetchWalkingLeaderboards()
                DispatchQueue.main.async {
                    self.walkingLeaderResult = result
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    struct walkingLeaderboardResult {
        let user : LeaderboardFUser?
        let top10: [LeaderboardFUser]
    }
    
    func fetchWalkingLeaderboards() async throws  -> walkingLeaderboardResult {
        let leaders = try await DatabaseManager.shared.fetchWalkingLeaderboards()
        let top10 = Array(leaders.sorted(by: { $0.count > $1.count}).prefix(10))
        let username = UserDefaults.standard.string(forKey: "username")
        
        if let username = username, !top10.contains(where: { $0.username == username}) {
            let user = leaders.first(where: { $0.username == username} )
            return walkingLeaderboardResult(user: user, top10: top10)
        } else {
            return walkingLeaderboardResult(user: nil, top10: top10)
        }
    }
    
    func postWalkingUpdateForUser() async throws {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            throw URLError(.badURL)
        }
        let distance = try await fetchCurrentWeekWalking()
        try await DatabaseManager.shared.postWalkingUpdateForUser(leader: LeaderboardFUser(username: username, count: Int(distance)))
    }
    
    private func fetchCurrentWeekWalking() async throws -> Double {
        try await withCheckedThrowingContinuation({ continuation in
            HealthManager.shared.fetchCurrentWeekWalkingDistance { result in
                continuation.resume(with: result)
            }
        })
    }
}
