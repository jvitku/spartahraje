//
//  UpcomingMatchesView.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import SwiftUI

struct UpcomingMatchesView: View {
    let matches: [Match]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Nadcházející zápasy na Letné - Všechny týmy:")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.upcomingText)

            VStack(spacing: 0) {
                ForEach(Array(matches.enumerated()), id: \.element.id) { index, match in
                    MatchCardView(match: match)

                    if index < matches.count - 1 {
                        Divider()
                            .background(Color.upcomingBorder.opacity(0.3))
                    }
                }
            }

            // Link to full calendar
            Link(destination: URL(string: "https://sparta.cz/cs/zapasy/1-muzi-a/2025-2026/kalendar")!) {
                HStack {
                    Text("📅 Zobrazit kompletní kalendář")
                        .font(.system(size: 14))
                        .foregroundColor(.upcomingText)
                }
                .padding(.top, 10)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(Color.upcomingBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.upcomingBorder, lineWidth: 2)
        )
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

#Preview {
    UpcomingMatchesView(
        matches: [
            Match(
                id: 1,
                homeTeam: TeamInfo(id: 2218, name: "Sparta Praha"),
                awayTeam: TeamInfo(id: 100, name: "Slavia Praha"),
                startTimestamp: Date().timeIntervalSince1970 + 3 * 24 * 60 * 60,
                venue: Venue(name: "epet ARENA", stadium: Stadium(name: "epet ARENA")),
                status: nil,
                homeScore: nil,
                awayScore: nil
            ),
            Match(
                id: 2,
                homeTeam: TeamInfo(id: 4866, name: "Sparta B"),
                awayTeam: TeamInfo(id: 200, name: "Viktoria Plzeň"),
                startTimestamp: Date().timeIntervalSince1970 + 5 * 24 * 60 * 60,
                venue: nil,
                status: nil,
                homeScore: nil,
                awayScore: nil
            )
        ]
    )
}
