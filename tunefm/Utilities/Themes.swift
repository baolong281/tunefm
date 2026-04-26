//
//  Themes.swift
//  tunefm
//
//  Created by dylan h on 4/25/26.
//

import SwiftUI
import UIKit

// central theme repository, holds the global styling so we only need to change things here
extension Font {
    private static func branded(_ name: String, size: CGFloat, weight: Font.Weight = .regular, relativeTo textStyle: Font.TextStyle = .body) -> Font {
        if UIFont(name: name, size: size) != nil {
            return .custom(name, size: size, relativeTo: textStyle)
        }

        return .system(size: size, weight: weight)
    }

    static let appDisplay = branded("HoeflerText-Black", size: 34, weight: .heavy, relativeTo: .largeTitle)
    static let appTitle = branded("HoeflerText-Regular", size: 22, weight: .regular, relativeTo: .title3)
    static let appBody = branded("HoeflerText-Regular", size: 16, weight: .regular, relativeTo: .body)
    static let appBodyBold = branded("HoeflerText-Black", size: 16, weight: .heavy, relativeTo: .body)
    static let appCaption = branded("HoeflerText-Regular", size: 12, weight: .regular, relativeTo: .caption)
}

extension Color {
  static let appBackground    = Color(red: 0.96, green: 0.98, blue: 0.96)
  static let appSurface       = Color(red: 0.91, green: 0.95, blue: 0.90)
  static let appSurfaceMuted  = Color(red: 0.83, green: 0.91, blue: 0.81)
  static let appField         = Color(red: 0.87, green: 0.94, blue: 0.85)
  static let appTextPrimary   = Color(red: 0.05, green: 0.12, blue: 0.05)
  static let appTextSecondary = Color(red: 0.29, green: 0.39, blue: 0.28)
  static let appAccent        = Color(red: 0.11, green: 0.48, blue: 0.23)
  static let appDestructive   = Color(red: 0.75, green: 0.22, blue: 0.17)
}
