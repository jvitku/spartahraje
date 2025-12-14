//
//  Colors.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import SwiftUI

extension Color {
    // Red theme (when playing at Letná)
    static let spartaRed = Color(red: 0.612, green: 0.110, blue: 0.180)
    static let spartaRedDark = Color(red: 0.420, green: 0.071, blue: 0.098)

    // Green theme (when not playing at Letná)
    static let spartaGreen = Color(red: 0.180, green: 0.490, blue: 0.196)
    static let spartaGreenDark = Color(red: 0.106, green: 0.369, blue: 0.125)

    // Badge colors
    static let mainTeamBadge = spartaRed
    static let otherTeamBadge = Color.orange

    // Upcoming matches section
    static let upcomingBackground = Color(red: 0.890, green: 0.949, blue: 0.992)
    static let upcomingBorder = Color(red: 0.129, green: 0.588, blue: 0.953)
    static let upcomingText = Color(red: 0.082, green: 0.396, blue: 0.753)
}

enum AppTheme {
    case red
    case green

    var gradientColors: [Color] {
        switch self {
        case .red:
            return [.spartaRed, .spartaRedDark]
        case .green:
            return [.spartaGreen, .spartaGreenDark]
        }
    }

    var headerColors: [Color] {
        switch self {
        case .red:
            return [.spartaRed, Color(red: 0.725, green: 0.133, blue: 0.204)]
        case .green:
            return [.spartaGreen, Color(red: 0.220, green: 0.557, blue: 0.235)]
        }
    }
}
