//
//  NoMatchView.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import SwiftUI

struct NoMatchView: View {
    let isPlayingElsewhere: Bool
    let match: Match?

    var body: some View {
        VStack(spacing: 20) {
            Text("☯️")
                .font(.system(size: 80))

            if isPlayingElsewhere, let match = match {
                // Playing but not at Letná
                Text("Ne, dnes Sparta nehraje na Letné")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 0.522, green: 0.392, blue: 0.016))
                    .multilineTextAlignment(.center)

                Text("Sparta dnes hraje \(match.isHome ? "doma (ale ne na Letné)" : "venku") proti týmu \(match.opponent.name)")
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

            } else {
                // No match at all
                Text("Ne, dnes Sparta nehraje")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 0.522, green: 0.392, blue: 0.016))
                    .multilineTextAlignment(.center)

                Text("Žádný zápas není naplánován na dnešek.")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
    }
}

#Preview {
    VStack {
        NoMatchView(isPlayingElsewhere: false, match: nil)
        Divider()
        NoMatchView(
            isPlayingElsewhere: true,
            match: Match(
                id: 1,
                homeTeam: TeamInfo(id: 100, name: "Some Team"),
                awayTeam: TeamInfo(id: 2218, name: "Sparta Praha"),
                startTimestamp: Date().timeIntervalSince1970,
                venue: nil,
                status: nil,
                homeScore: nil,
                awayScore: nil
            )
        )
    }
}
