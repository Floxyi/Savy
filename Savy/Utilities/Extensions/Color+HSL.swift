//
//  Color+HSL.swift
//  Savy
//
//  Created by Florian Winkler on 24.08.24.
//

import SwiftUI

/// An extension to the `Color` struct that allows creation of a color from HSL (Hue, Saturation, Lightness) values.
extension Color {
    /// Initializes a `Color` from HSL (Hue, Saturation, Lightness) values.
    ///
    /// - Parameter hue: The hue of the color, ranging from 0 to 360 (degrees).
    /// - Parameter saturation: The saturation of the color, ranging from 0 to 100 (percentage).
    /// - Parameter lightness: The lightness of the color, ranging from 0 to 100 (percentage).
    ///
    /// The color is created based on the provided HSL values. If the saturation is zero, the color will be a shade of gray.
    ///
    /// - Note: The hue is clamped between 0 and 360, saturation and lightness between 0 and 100.
    init(hue: Double, saturation: Double, lightness: Double) {
        let h = max(0, min(360, hue)) / 360.0
        let s = max(0, min(100, saturation)) / 100.0
        let l = max(0, min(100, lightness)) / 100.0

        // If the saturation is zero, the color is gray (no hue or saturation)
        if s == 0 {
            let gray = Double(l)
            self.init(red: gray, green: gray, blue: gray)
            return
        }

        // Helper function to convert hue to RGB
        func hueToRGB(_ p: Double, _ q: Double, _ t: Double) -> Double {
            var t = t
            if t < 0 {
                t += 1
            }
            if t > 1 {
                t -= 1
            }
            if t < 1 / 6 {
                return p + (q - p) * 6 * t
            }
            if t < 1 / 2 {
                return q
            }
            if t < 2 / 3 {
                return p + (q - p) * (2 / 3 - t) * 6
            }
            return p
        }

        let q = l < 0.5 ? l * (1 + s) : l + s - l * s
        let p = 2 * l - q

        // Convert HSL to RGB using the helper function
        let r = hueToRGB(p, q, h + 1 / 3)
        let g = hueToRGB(p, q, h)
        let b = hueToRGB(p, q, h - 1 / 3)

        // Initialize the color with the computed RGB values
        self.init(red: r, green: g, blue: b)
    }
}
