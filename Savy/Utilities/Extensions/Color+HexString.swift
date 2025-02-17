//
//  Color+HexString.swift
//  Savy
//
//  Created by Florian Winkler on 25.08.24.
//

import SwiftUI

/// An extension to the `Color` struct that provides functionality for creating colors from hex strings and converting them back to hex strings.
extension Color {
    /// Initializes a `Color` from a hex string representation.
    ///
    /// The hex string can be in one of the following formats:
    /// - RGB (12-bit) format: `#RGB`
    /// - RGB (24-bit) format: `#RRGGBB`
    /// - ARGB (32-bit) format: `#AARRGGBB`
    ///
    /// - Parameter hexString: A string representing the color in hex format (e.g., "#FF5733" or "#FF5733FF").
    /// - Returns: A `Color` if the hex string is valid, otherwise `nil`.
    init?(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    /// Converts a `Color` to its hexadecimal string representation.
    ///
    /// The resulting string will be in RGB (24-bit) format (e.g., "#RRGGBB").
    ///
    /// - Returns: A hex string representation of the color (e.g., "#FF5733").
    var hexString: String {
        let components = cgColor?.components ?? [0, 0, 0, 1]
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}
