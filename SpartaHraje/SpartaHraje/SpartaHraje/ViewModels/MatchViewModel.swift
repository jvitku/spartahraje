//
//  MatchViewModel.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import Foundation
import Combine

@MainActor
class MatchViewModel: ObservableObject {
    @Published var todayMatch: Match?
    @Published var upcomingMatches: [Match] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var theme: AppTheme = .red

    private let apiService = APIService.shared
    private let notificationManager = NotificationManager.shared

    // MARK: - Fetch Data

    func fetchMatchData() async {
        isLoading = true
        errorMessage = nil

        do {
            // Fetch today's match for main team
            todayMatch = try await apiService.fetchTodayMatch(teamId: Constants.mainTeamID)

            // Fetch upcoming home matches from all teams
            upcomingMatches = try await apiService.fetchUpcomingHomeMatches()

            // Schedule notifications for Letná matches
            await notificationManager.scheduleNotifications(for: upcomingMatches)

            // Update theme based on today's match
            updateTheme()

            print("✅ Data fetched successfully")
            print("   Today's match: \(todayMatch?.homeTeam.name ?? "None") vs \(todayMatch?.awayTeam.name ?? "None")")
            print("   Upcoming matches: \(upcomingMatches.count)")
            print("   Theme: \(theme)")

        } catch let error as APIError {
            errorMessage = error.localizedDescription
            print("❌ API Error: \(error.localizedDescription)")
        } catch {
            errorMessage = "Nepodařilo se načíst data: \(error.localizedDescription)"
            print("❌ Error: \(error.localizedDescription)")
        }

        isLoading = false
    }

    private func updateTheme() {
        if let match = todayMatch {
            // Green theme if not playing at Letná
            theme = match.isAtLetna ? .red : .green
        } else {
            // Red theme if no match today
            theme = .red
        }
    }

    // MARK: - Refresh

    func refresh() async {
        await fetchMatchData()
    }
}
