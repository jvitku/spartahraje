//
//  DateFormatters.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import Foundation

extension DateFormatter {
    static let czechDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "cs_CZ")
        formatter.dateFormat = "dd. MM. yyyy"
        return formatter
    }()

    static let czechTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "cs_CZ")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    static let czechDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "cs_CZ")
        formatter.dateFormat = "dd. MM. yyyy HH:mm"
        return formatter
    }()
}

extension Date {
    func czechDateString() -> String {
        DateFormatter.czechDate.string(from: self)
    }

    func czechTimeString() -> String {
        DateFormatter.czechTime.string(from: self)
    }

    func czechDateTimeString() -> String {
        DateFormatter.czechDateTime.string(from: self)
    }

    func isSameDay(as otherDate: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: otherDate)
    }

    func isToday() -> Bool {
        isSameDay(as: Date())
    }
}
