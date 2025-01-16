//
//  Color+HSL.swift
//  Savy
//
//  Created by Florian Winkler on 24.08.24.
//

import SwiftUI

extension Color {
    init(hue: Double, saturation: Double, lightness: Double) {
        let h = max(0, min(360, hue)) / 360.0
        let s = max(0, min(100, saturation)) / 100.0
        let l = max(0, min(100, lightness)) / 100.0

        if s == 0 {
            let gray = Double(l)
            self.init(red: gray, green: gray, blue: gray)
            return
        }

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

        let r = hueToRGB(p, q, h + 1 / 3)
        let g = hueToRGB(p, q, h)
        let b = hueToRGB(p, q, h - 1 / 3)

        self.init(red: r, green: g, blue: b)
    }
}
