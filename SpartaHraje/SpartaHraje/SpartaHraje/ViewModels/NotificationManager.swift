//
//  NotificationManager.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import Foundation
import UserNotifications
import Combine

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    @Published var pendingNotifications: [UNNotificationRequest] = []

    private let center = UNUserNotificationCenter.current()

    private init() {}

    // MARK: - Authorization

    func requestAuthorization() async {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            await updateAuthorizationStatus()

            if granted {
                print("✅ Notification authorization granted")
            } else {
                print("❌ Notification authorization denied")
            }
        } catch {
            print("❌ Error requesting notification authorization: \(error)")
        }
    }

    func updateAuthorizationStatus() async {
        let settings = await center.notificationSettings()
        authorizationStatus = settings.authorizationStatus
    }

    // MARK: - Schedule Notifications

    func scheduleNotifications(for matches: [Match]) async {
        // First, check if we have permission
        await updateAuthorizationStatus()
        guard authorizationStatus == .authorized else {
            print("⚠️ Notifications not authorized, skipping scheduling")
            return
        }

        // Remove all pending notifications first
        await removeAllScheduledNotifications()

        // Filter only Letná home matches
        let letnaMatches = matches.filter { $0.isAtLetna }

        print("📅 Scheduling notifications for \(letnaMatches.count) Letná matches...")

        for match in letnaMatches {
            // Schedule 3 days before
            await scheduleNotification(for: match, daysBefore: 3)

            // Schedule 1 day before
            await scheduleNotification(for: match, daysBefore: 1)
        }

        // Update pending notifications list
        await updatePendingNotifications()

        print("✅ Scheduled \(pendingNotifications.count) notifications")
    }

    private func scheduleNotification(for match: Match, daysBefore: Int) async {
        let notificationDate = Calendar.current.date(
            byAdding: .day,
            value: -daysBefore,
            to: match.startDate
        )

        guard let notificationDate = notificationDate,
              notificationDate > Date() else {
            // Don't schedule notifications in the past
            return
        }

        let content = UNMutableNotificationContent()

        // Determine team name, date and time
        let teamName = match.spartaTeam?.name ?? "Sparta"
        let opponent = match.opponent.name
        let matchDate = match.startDate.czechDateString()
        let startTime = match.startDate.czechTimeString()
        let endTime = match.endDate.czechTimeString()
        let dateTimeRange = "\(matchDate) \(startTime)-\(endTime)"

        if daysBefore == 3 {
            content.title = "Sparta hraje za 3 dny!"
            content.body = "\(teamName) vs \(opponent) na Letné (\(dateTimeRange))"
        } else if daysBefore == 1 {
            content.title = "Sparta hraje zítra!"
            content.body = "\(teamName) vs \(opponent) na Letné (\(dateTimeRange))"
        }

        content.sound = .default
        content.badge = 1

        // Create trigger
        let dateComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: notificationDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // Create request with unique identifier
        let identifier = Constants.notificationID(matchID: match.id, daysBefore: daysBefore)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        do {
            try await center.add(request)
            print("✅ Scheduled: \(identifier) for \(notificationDate.czechDateTimeString())")
        } catch {
            print("❌ Error scheduling notification \(identifier): \(error)")
        }
    }

    // MARK: - Test Notification

    func testNotification() async {
        let content = UNMutableNotificationContent()
        content.title = "Test: Sparta hraje za 3 dny!"
        content.body = "Sparta Praha vs Test Team na Letné (20. 12. 2025 18:00-20:00)"
        content.sound = .default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "test-notification", content: content, trigger: trigger)

        do {
            try await center.add(request)
            print("✅ Test notification scheduled for 10 seconds from now")
            await updatePendingNotifications()
        } catch {
            print("❌ Error scheduling test notification: \(error)")
        }
    }

    // MARK: - Manage Notifications

    func removeAllScheduledNotifications() async {
        center.removeAllPendingNotificationRequests()
        await updatePendingNotifications()
        print("🗑️ Removed all pending notifications")
    }

    func updatePendingNotifications() async {
        pendingNotifications = await center.pendingNotificationRequests()
    }
}
