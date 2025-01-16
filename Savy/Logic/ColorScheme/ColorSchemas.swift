//
//  ColorSchemas.swift
//  Savy
//
//  Created by Florian Winkler on 25.08.24.
//

import SwiftUI

struct ColorSchemes {
    static func lightMode() -> ColorScheme {
        return ColorScheme(
            mode: .light,
            background: Color(hue: 0, saturation: 0, lightness: 95),
            bar: Color(hue: 0, saturation: 0, lightness: 84),
            barIcons: Color(hue: 0, saturation: 0, lightness: 67),
            accent1: Color(hue: 0, saturation: 0, lightness: 75),
            accent2: Color(hue: 0, saturation: 0, lightness: 36),
            font: Color(hue: 0, saturation: 0, lightness: 45)
        )
    }

    static func darkMode() -> ColorScheme {
        return ColorScheme(
            mode: .dark,
            background: Color(hue: 0, saturation: 0, lightness: 22),
            bar: Color(hue: 0, saturation: 0, lightness: 20),
            barIcons: Color(hue: 0, saturation: 0, lightness: 42),
            accent1: Color(hue: 0, saturation: 0, lightness: 31),
            accent2: Color(hue: 0, saturation: 0, lightness: 80),
            font: Color(hue: 0, saturation: 0, lightness: 100)
        )
    }

    static func coloredLightMode(hue: Double) -> ColorScheme {
        return ColorScheme(
            mode: .coloredLight,
            background: Color(hue: hue, saturation: 27, lightness: 45),
            bar: Color(hue: hue, saturation: 30, lightness: 33),
            barIcons: Color(hue: hue, saturation: 41, lightness: 81),
            accent1: Color(hue: hue, saturation: 26, lightness: 40),
            accent2: Color(hue: hue, saturation: 41, lightness: 68),
            font: Color(hue: hue, saturation: 62, lightness: 93)
        )
    }

    static func coloredDarkMode(hue: Double) -> ColorScheme {
        return ColorScheme(
            mode: .coloredDark,
            background: Color(hue: hue, saturation: 29, lightness: 33),
            bar: Color(hue: hue, saturation: 27, lightness: 45),
            barIcons: Color(hue: hue, saturation: 41, lightness: 81),
            accent1: Color(hue: hue, saturation: 26, lightness: 40),
            accent2: Color(hue: hue, saturation: 41, lightness: 68),
            font: Color(hue: hue, saturation: 62, lightness: 93)
        )
    }
}
