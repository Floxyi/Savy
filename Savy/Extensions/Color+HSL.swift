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
