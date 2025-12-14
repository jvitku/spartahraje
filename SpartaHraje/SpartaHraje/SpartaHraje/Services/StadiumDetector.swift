//
//  StadiumDetector.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import Foundation

struct StadiumDetector {
    static let letnaNames = [
        "letná",
        "letna",
        "generali arena",
        "generali česká pojišťovna arena",
        "epet arena",
        "epet"
    ]

    static func isLetna(_ venueName: String) -> Bool {
        let normalized = venueName.lowercased()
        return letnaNames.contains { normalized.contains($0) }
    }
}
