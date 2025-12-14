//
//  APIService.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import Foundation
import UIKit

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case httpError(Int)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Neplatná URL adresa"
        case .networkError(let error):
            return "Chyba sítě: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Chyba při zpracování dat: \(error.localizedDescription)"
        case .httpError(let code):
            return "HTTP chyba: \(code)"
        }
    }
}

actor APIService {
    static let shared = APIService()

    private let session: URLSession
    private var imageCache: [Int: Data] = [:]

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 30
        self.session = URLSession(configuration: config)
    }

    // MARK: - Fetch Events

    func fetchLastEvents(teamId: Int) async throws -> [Match] {
        let urlString = "\(Constants.apiBaseURL)/team/\(teamId)/events/last/0"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.httpError(0)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            let eventsResponse = try decoder.decode(EventsResponse.self, from: data)
            return eventsResponse.events ?? []
        } catch {
            throw APIError.decodingError(error)
        }
    }

    func fetchNextEvents(teamId: Int) async throws -> [Match] {
        let urlString = "\(Constants.apiBaseURL)/team/\(teamId)/events/next/0"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.httpError(0)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            let eventsResponse = try decoder.decode(EventsResponse.self, from: data)
            return eventsResponse.events ?? []
        } catch {
            throw APIError.decodingError(error)
        }
    }

    // MARK: - Fetch Today's Match

    func fetchTodayMatch(teamId: Int) async throws -> Match? {
        // Fetch both last and next events in parallel
        async let lastEvents = fetchLastEvents(teamId: teamId)
        async let nextEvents = fetchNextEvents(teamId: teamId)

        let (last, next) = try await (lastEvents, nextEvents)

        // Combine all events
        let allEvents = last + next

        // Find today's match
        let today = Date()
        return allEvents.first { match in
            match.startDate.isToday()
        }
    }

    // MARK: - Fetch Upcoming Home Matches

    func fetchUpcomingHomeMatches() async throws -> [Match] {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let tomorrowTimestamp = tomorrow.timeIntervalSince1970

        // Fetch matches from all teams in parallel
        return try await withThrowingTaskGroup(of: [Match].self) { group in
            for team in Team.all {
                group.addTask {
                    let nextEvents = try await self.fetchNextEvents(teamId: team.id)

                    // Filter for home matches after today
                    return nextEvents.filter { match in
                        let isHome = match.homeTeam.id == team.id
                        let isFuture = match.startTimestamp > tomorrowTimestamp
                        return isHome && isFuture
                    }
                }
            }

            var allMatches: [Match] = []
            for try await matches in group {
                allMatches.append(contentsOf: matches)
            }

            // Sort by date and take first 10
            return allMatches
                .sorted { $0.startTimestamp < $1.startTimestamp }
                .prefix(10)
                .map { $0 }
        }
    }

    // MARK: - Image Fetching

    func fetchTeamImage(teamId: Int) async throws -> Data {
        // Check cache first
        if let cached = imageCache[teamId] {
            return cached
        }

        let urlString = "\(Constants.apiBaseURL)/team/\(teamId)/image"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(0)
        }

        // Cache the image
        imageCache[teamId] = data
        return data
    }
}
