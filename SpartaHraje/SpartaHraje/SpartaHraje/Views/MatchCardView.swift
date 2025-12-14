//
//  MatchCardView.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import SwiftUI

struct MatchCardView: View {
    let match: Match

    var body: some View {
        HStack(spacing: 10) {
            // Team badge
            if let team = match.spartaTeam {
                TeamBadge(team: team)
            }

            VStack(alignment: .leading, spacing: 4) {
                // Date and time
                Text("\(match.startDate.czechDateString()) \(match.startDate.czechTimeString())-\(match.endDate.czechTimeString())")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.upcomingText)

                // Opponent
                Text(match.opponent.name)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
            }

            Spacer()

            // Link to event
            Link(destination: URL(string: "https://www.sofascore.com/event/\(match.id)")!) {
                Text("🔗")
                    .font(.system(size: 16))
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    VStack {
        MatchCardView(
            match: Match(
                id: 1,
                homeTeam: TeamInfo(id: 2218, name: "Sparta Praha"),
                awayTeam: TeamInfo(id: 100, name: "Slavia Praha"),
                startTimestamp: Date().timeIntervalSince1970 + 3 * 24 * 60 * 60,
                venue: Venue(name: "epet ARENA", stadium: Stadium(name: "epet ARENA")),
                status: nil,
                homeScore: nil,
                awayScore: nil
            )
        )
        Divider()
        MatchCardView(
            match: Match(
                id: 2,
                homeTeam: TeamInfo(id: 4866, name: "Sparta B"),
                awayTeam: TeamInfo(id: 200, name: "Viktoria Plzeň"),
                startTimestamp: Date().timeIntervalSince1970 + 5 * 24 * 60 * 60,
                venue: nil,
                status: nil,
                homeScore: nil,
                awayScore: nil
            )
        )
    }
    .padding()
}
