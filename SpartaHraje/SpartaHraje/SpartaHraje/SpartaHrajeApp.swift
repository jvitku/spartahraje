//
//  SpartaHrajeApp.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import SwiftUI
import BackgroundTasks

@main
struct SpartaHrajeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        print("🚀 App launched")

        // Register background task
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Constants.backgroundRefreshTaskID,
            using: nil
        ) { task in
            self.handleBackgroundRefresh(task: task as! BGAppRefreshTask)
        }

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("📱 App entered background")
        scheduleBackgroundRefresh()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("📱 App entering foreground")
        // Data will be refreshed by MainView's .task modifier
    }

    // MARK: - Background Refresh

    private func scheduleBackgroundRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: Constants.backgroundRefreshTaskID)

        // Schedule for 24 hours from now
        request.earliestBeginDate = Date(timeIntervalSinceNow: 24 * 60 * 60)

        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ Background refresh scheduled for \(request.earliestBeginDate!)")
        } catch {
            print("❌ Failed to schedule background refresh: \(error)")
        }
    }

    private func handleBackgroundRefresh(task: BGAppRefreshTask) {
        print("🔄 Background refresh started")

        // Schedule next refresh
        scheduleBackgroundRefresh()

        // Set expiration handler
        task.expirationHandler = {
            print("⏰ Background task expired")
        }

        // Perform the actual refresh
        Task {
            do {
                // Fetch data
                let apiService = APIService.shared
                let _ = try await apiService.fetchTodayMatch(teamId: Constants.mainTeamID)
                let upcomingMatches = try await apiService.fetchUpcomingHomeMatches()

                // Schedule notifications
                await NotificationManager.shared.scheduleNotifications(for: upcomingMatches)

                print("✅ Background refresh completed successfully")
                task.setTaskCompleted(success: true)

            } catch {
                print("❌ Background refresh failed: \(error)")
                task.setTaskCompleted(success: false)
            }
        }
    }
}
