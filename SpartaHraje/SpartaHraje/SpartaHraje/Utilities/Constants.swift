//
//  Constants.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import Foundation

enum Constants {
    // API Configuration
    static let apiBaseURL = "https://api.sofascore.com/api/v1"
    static let mainTeamID = 2218

    // Background Task
    static let backgroundRefreshTaskID = "com.spartahraje.refresh"

    // Notification identifiers
    static func notificationID(matchID: Int, daysBefore: Int) -> String {
        return "sparta-match-\(matchID)-\(daysBefore)d"
    }

    // Cache
    static let cacheExpirationInterval: TimeInterval = 3600 // 1 hour
    static let lastUpdateKey = "lastAPIUpdate"
}
