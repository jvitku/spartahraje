//
//  MatchTodayView.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import SwiftUI

struct MatchTodayView: View {
    let match: Match

    var body: some View {
        VStack(spacing: 20) {
            // Emoji
            Text("⚽")
                .font(.system(size: 80))

            // Title
            Text("Sparta hraje na Letné!")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(red: 0.082, green: 0.341, blue: 0.141))

            // Match details card
            VStack(spacing: 0) {
                // Teams
                HStack(spacing: 20) {
                    // Home team
                    TeamLogoView(teamId: match.homeTeam.id, teamName: match.homeTeam.name)
                        .frame(maxWidth: .infinity)

                    // VS
                    Text("VS")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.spartaRed)

                    // Away team
                    TeamLogoView(teamId: match.awayTeam.id, teamName: match.awayTeam.name)
                        .frame(maxWidth: .infinity)
                }
                .padding()

                Divider()

                // Match time with team badge
                HStack {
                    // Team badge
                    if let team = match.spartaTeam {
                        TeamBadge(team: team)
                    }

                    // Time range
                    Text("\(match.startDate.czechDateTimeString())-\(match.endDate.czechTimeString())")
                        .font(.system(size: 14))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)

                // Venue (if available)
                if let venueName = match.venue?.stadium?.name ?? match.venue?.name {
                    Divider()
                    HStack {
                        Text("Stadion:")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.spartaRed)
                        Text(venueName)
                            .font(.system(size: 14))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Link to SofaScore
                Divider()
                Link(destination: URL(string: "https://www.sofascore.com/event/\(match.id)")!) {
                    HStack {
                        Text("🔗 Zobrazit na SofaScore")
                            .font(.system(size: 14))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding(.vertical, 40)
    }
}

struct TeamLogoView: View {
    let teamId: Int
    let teamName: String

    @State private var imageData: Data?

    var body: some View {
        VStack(spacing: 10) {
            if let imageData = imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
            } else {
                // Placeholder
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay(
                        ProgressView()
                    )
            }

            Text(teamName)
                .font(.system(size: 14, weight: .medium))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .task {
            do {
                imageData = try await APIService.shared.fetchTeamImage(teamId: teamId)
            } catch {
                print("Failed to load image for team \(teamId): \(error)")
            }
        }
    }
}

struct TeamBadge: View {
    let team: Team

    var body: some View {
        Text(team.name)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(team.isMainTeam ? Color.mainTeamBadge : Color.otherTeamBadge)
            .cornerRadius(4)
    }
}

#Preview {
    MatchTodayView(
        match: Match(
            id: 12345,
            homeTeam: TeamInfo(id: 2218, name: "Sparta Praha"),
            awayTeam: TeamInfo(id: 100, name: "Slavia Praha"),
            startTimestamp: Date().timeIntervalSince1970,
            venue: Venue(name: "epet ARENA", stadium: Stadium(name: "epet ARENA")),
            status: nil,
            homeScore: nil,
            awayScore: nil
        )
    )
}
