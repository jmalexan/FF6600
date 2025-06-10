//
//  TextParsing.swift
//  Hackery
//
//  Created by Jonathan Alexander on 9/25/24.
//

import Foundation
import HTMLEntities

func parseContent(_ content: String) -> String {
    content
        .replacing(/<p>/, with: "\n")
        .replacingOccurrences(of: "<em>(.*)<\\/em>", with: "*$1*", options: .regularExpression)
        .replacingOccurrences(of: "<i>(.*)<\\/i>", with: "*$1*", options: .regularExpression)
        .replacingOccurrences(of: "<a href=\"(.*)\" rel=\"nofollow\">(.*)<\\/a>", with: "[$2]($1)", options: .regularExpression)
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .htmlUnescape()
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
