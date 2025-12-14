//
//  MainView.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MatchViewModel()
    @StateObject private var notificationManager = NotificationManager.shared

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: viewModel.theme.gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HeaderView(theme: viewModel.theme)

                    // Content
                    ZStack {
                        Color.white

                        if viewModel.isLoading {
                            LoadingView()
                        } else if let errorMessage = viewModel.errorMessage {
                            ErrorView(message: errorMessage, onRetry: {
                                Task {
                                    await viewModel.refresh()
                                }
                            })
                        } else {
                            ContentView(
                                viewModel: viewModel,
                                notificationManager: notificationManager
                            )
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
        .task {
            // Request notification permissions
            await notificationManager.requestAuthorization()

            // Fetch initial data
            await viewModel.fetchMatchData()
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: MatchViewModel
    @ObservedObject var notificationManager: NotificationManager

    var body: some View {
        VStack(spacing: 0) {
            // Today's match section
            if let match = viewModel.todayMatch {
                if match.isAtLetna {
                    // Playing at Letná
                    MatchTodayView(match: match)
                } else {
                    // Playing elsewhere
                    NoMatchView(isPlayingElsewhere: true, match: match)
                }
            } else {
                // No match today
                NoMatchView(isPlayingElsewhere: false, match: nil)
            }

            // Upcoming matches
            if !viewModel.upcomingMatches.isEmpty {
                UpcomingMatchesView(matches: viewModel.upcomingMatches)
            }

            // Debug info
            DebugInfoView(match: viewModel.todayMatch, notificationManager: notificationManager)

            Spacer(minLength: 20)
        }
    }
}

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Nepodařilo se načíst informace o zápasech.")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .padding()
                .background(Color(red: 0.973, green: 0.843, blue: 0.855))
                .cornerRadius(5)
                .padding(.horizontal)

            Button(action: onRetry) {
                Text("Zkusit znovu")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.spartaRed)
                    .cornerRadius(8)
            }
        }
        .padding(40)
    }
}

#Preview {
    MainView()
}
