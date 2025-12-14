//
//  Match.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import Foundation

struct Match: Identifiable, Codable {
    let id: Int
    let homeTeam: TeamInfo
    let awayTeam: TeamInfo
    let startTimestamp: TimeInterval
    let venue: Venue?
    let status: MatchStatus?
    let homeScore: Score?
    let awayScore: Score?

    // Computed properties
    var startDate: Date {
        Date(timeIntervalSince1970: startTimestamp)
    }

    var endDate: Date {
        Date(timeIntervalSince1970: startTimestamp + (2 * 60 * 60)) // +2 hours
    }

    var isHome: Bool {
        Team.all.contains { $0.id == homeTeam.id }
    }

    var isAtLetna: Bool {
        guard isHome else { return false }

        // Get venue name
        guard let venueName = venue?.stadium?.name ?? venue?.name else {
            // Assume Letná when venue is empty for home games
            return true
        }

        return StadiumDetector.isLetna(venueName)
    }

    var spartaTeam: Team? {
        Team.all.first { $0.id == homeTeam.id || $0.id == awayTeam.id }
    }

    var opponent: TeamInfo {
        isHome ? awayTeam : homeTeam
    }
}

struct TeamInfo: Codable {
    let id: Int
    let name: String
}

struct Score: Codable {
    let display: Int?
}

struct MatchStatus: Codable {
    let type: String?
}
