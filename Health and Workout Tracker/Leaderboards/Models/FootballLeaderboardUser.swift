//
//  FootballLeaderboardUser.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 27/09/2024.
//

import Foundation

struct LeaderboardFUser: Codable, Identifiable {
    let id = UUID()
    let username: String
    let count: Int

}
