//
//  DateHelper.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

// Utilities/Date+Extensions.swift
import Foundation

class DateHelper {
    static func timeAgoDisplay(date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        switch seconds {
        case 0..<60:       return "just now"
        case 60..<3600:    return "\(seconds / 60)m ago"
        case 3600..<86400: return "\(seconds / 3600)h ago"
        default:           return "\(seconds / 86400)d ago"
        }
    }
}
