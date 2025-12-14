//
//  Venue.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import Foundation

struct Venue: Codable {
    let name: String?
    let stadium: Stadium?
}

struct Stadium: Codable {
    let name: String?
}
