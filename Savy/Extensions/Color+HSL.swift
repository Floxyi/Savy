//
//  Color+HSL.swift
//  Savy
//
//  Created by Florian Winkler on 24.08.24.
//

import SwiftUI

extension Color {
    init(hue: Double, saturation: Double, lightness: Double) {
        let h = hue / 360.0
        let s = saturation / 100.0
        let l = lightness / 100.0

        let t2: Double
        if l < 0.5 {
            t2 = l * (1 + s)
        } else {
            t2 = l + s - l * s
        }
        let t1 = 2 * l - t2

        func hueToRGB(_ t1: Double, _ t2: Double, _ hue: Double) -> Double {
            var hue = hue
            if hue < 0 { hue += 1 }
            if hue > 1 { hue -= 1 }
            if 6 * hue < 1 {
                return t1 + (t2 - t1) * 6 * hue
            }
            if 2 * hue < 1 {
                return t2
            }
            if 3 * hue < 1 {
                return t1 + (t2 - t1) * (2 / 3 - hue) * 6
            }
            return t1
        }

        let r = hueToRGB(t1, t2, h + 1 / 3)
        let g = hueToRGB(t1, t2, h)
        let b = hueToRGB(t1, t2, h - 1 / 3)

        self.init(red: r, green: g, blue: b)
    }
}

extension Color {
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
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    var hexString: String {
        let components = self.cgColor?.components ?? [0, 0, 0, 1]
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}
