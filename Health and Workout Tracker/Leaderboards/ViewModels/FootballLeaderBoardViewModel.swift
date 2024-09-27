//
//  FootballLeaderBoardViewModel.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 27/09/2024.
//

import Foundation

class LeaderboardViewModel: ObservableObject {
    
    @Published var leaders = [LeaderboardFUser]()
    
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
                try await postMinutesUpdateForUser(username: "xcode", count: 123)
                let result = try await fetchLeaderboards()
                DispatchQueue.main.async {
                    self.leaders = result.top10
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
        
        if let username = username {
            let user = leaders.first(where: { $0.username == username} )
            return LeaderboardResult(user: user, top10: top10)
        } else {
            return LeaderboardResult(user: nil, top10: top10)
        }
    }
    
    func postMinutesUpdateForUser(username: String, count: Int) async throws {
        try await DatabaseManager.shared.postMinutesUpdateForUser(leader: LeaderboardFUser(username: username, count: count))
    }
}
