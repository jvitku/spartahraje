//
//  Team.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import Foundation

struct Team: Identifiable, Codable {
    let id: Int
    let name: String
    let isMainTeam: Bool

    static let all = [
        Team(id: 2218, name: "Muži A", isMainTeam: true),
        Team(id: 4866, name: "Muži B (U21)", isMainTeam: false),
        Team(id: 38255, name: "Ženy", isMainTeam: false)
    ]

    static let mainTeam = all[0]
}
