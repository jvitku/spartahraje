//
//  DebugInfoView.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import SwiftUI

struct DebugInfoView: View {
    let match: Match?
    @ObservedObject var notificationManager: NotificationManager

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Toggle header
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(isExpanded ? "▼" : "▶")
                        .font(.system(size: 14, weight: .bold))
                    Text("Debug informace")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                }
                .foregroundColor(Color(red: 0.522, green: 0.392, blue: 0.016))
                .padding()
            }

            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    if let match = match {
                        DebugRow(label: "Match ID", value: "\(match.id)")
                        DebugRow(label: "Domácí tým", value: "\(match.homeTeam.name) (ID: \(match.homeTeam.id))")
                        DebugRow(label: "Hostující tým", value: "\(match.awayTeam.name) (ID: \(match.awayTeam.id))")
                        DebugRow(label: "Je Sparta doma?", value: match.isHome ? "Ano" : "Ne")
                        DebugRow(label: "Čas začátku", value: match.startDate.czechDateTimeString())
                        DebugRow(label: "Čas konce", value: match.endDate.czechTimeString())
                        DebugRow(label: "Název stadionu z API", value: match.venue?.stadium?.name ?? "(prázdné!)")

                        if let venue = match.venue {
                            DebugRow(label: "Venue objekt", value: "\(venue)")
                        } else {
                            DebugRow(label: "Venue objekt", value: "undefined")
                        }

                        DebugRow(label: "Rozpoznáno jako Letná?", value: match.isAtLetna ? "Ano" : "Ne")
                        DebugRow(label: "Stav zápasu", value: match.status?.type ?? "neznámý")

                        let homeScore = match.homeScore?.display.map { "\($0)" } ?? "?"
                        let awayScore = match.awayScore?.display.map { "\($0)" } ?? "?"
                        DebugRow(label: "Skóre", value: "\(homeScore) - \(awayScore)")
                    } else {
                        Text("Žádný zápas dnes")
                            .font(.system(size: 14))
                            .padding(.vertical, 4)
                    }

                    Divider()
                        .background(Color(red: 1.0, green: 0.95, blue: 0.8))

                    DebugRow(label: "Pending notifications", value: "\(notificationManager.pendingNotifications.count)")

                    // Test notification button
                    Button(action: {
                        Task {
                            await notificationManager.testNotification()
                        }
                    }) {
                        Text("Test Notification (10s)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.upcomingText)
                            .cornerRadius(6)
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .background(Color(red: 1.0, green: 0.95, blue: 0.8))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 1.0, green: 0.757, blue: 0.027), lineWidth: 2)
        )
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 20)
        .task {
            await notificationManager.updatePendingNotifications()
        }
    }
}

struct DebugRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\(label):")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(red: 0.522, green: 0.392, blue: 0.016))

            Text(value)
                .font(.system(size: 14))
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    DebugInfoView(
        match: Match(
            id: 12345,
            homeTeam: TeamInfo(id: 2218, name: "Sparta Praha"),
            awayTeam: TeamInfo(id: 100, name: "Slavia Praha"),
            startTimestamp: Date().timeIntervalSince1970,
            venue: Venue(name: "epet ARENA", stadium: Stadium(name: "epet ARENA")),
            status: MatchStatus(type: "finished"),
            homeScore: Score(display: 2),
            awayScore: Score(display: 1)
        ),
        notificationManager: NotificationManager.shared
    )
}
