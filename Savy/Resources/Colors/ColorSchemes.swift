//
//  ColorSchemes.swift
//  Savy
//
//  Created by Florian Winkler on 25.08.24.
//

import SwiftUI

/// A utility class that provides pre-defined color schemes for the app.
///
/// The `ColorSchemes` enum offers different color scheme configurations based on the selected mode:
/// light, dark, and colored modes. The colored modes take a hue value that allows for customization
/// of the primary color for the scheme. These color schemes are applied to various UI elements
/// such as the background, navigation bar, icons, and text in the app.
///
/// - `lightMode`: Provides a light color scheme with lighter background and font colors.
enum ColorSchemes {
    /// Returns a light mode color scheme with a bright background and muted colors for accents and fonts.
    ///
    /// - Returns: A `ColorScheme` object with properties set for light mode.
    static func lightMode() -> ColorScheme {
        ColorScheme(
            mode: .light,
            background: Color(hue: 0, saturation: 0, lightness: 95),
            bar: Color(hue: 0, saturation: 0, lightness: 84),
            barIcons: Color(hue: 0, saturation: 0, lightness: 67),
            accent1: Color(hue: 0, saturation: 0, lightness: 75),
            accent2: Color(hue: 0, saturation: 0, lightness: 36),
            font: Color(hue: 0, saturation: 0, lightness: 45)
        )
    }

    /// Returns a dark mode color scheme with dark background and lighter text for contrast.
    ///
    /// - Returns: A `ColorScheme` object with properties set for dark mode.
    static func darkMode() -> ColorScheme {
        ColorScheme(
            mode: .dark,
            background: Color(hue: 0, saturation: 0, lightness: 22),
            bar: Color(hue: 0, saturation: 0, lightness: 15),
            barIcons: Color(hue: 0, saturation: 0, lightness: 42),
            accent1: Color(hue: 0, saturation: 0, lightness: 31),
            accent2: Color(hue: 0, saturation: 0, lightness: 80),
            font: Color(hue: 0, saturation: 0, lightness: 100)
        )
    }

    /// Returns a colored light mode color scheme where the primary color is based on the provided hue.
    ///
    /// - Parameter hue: The hue value to define the primary color tone.
    /// - Returns: A `ColorScheme` object with properties set for a customizable colored light mode.
    static func coloredLightMode(hue: Double) -> ColorScheme {
        ColorScheme(
            mode: .coloredLight,
            background: Color(hue: hue, saturation: 27, lightness: 45),
            bar: Color(hue: hue, saturation: 30, lightness: 33),
            barIcons: Color(hue: hue, saturation: 41, lightness: 81),
            accent1: Color(hue: hue, saturation: 26, lightness: 40),
            accent2: Color(hue: hue, saturation: 41, lightness: 68),
            font: Color(hue: hue, saturation: 62, lightness: 93)
        )
    }

    /// Returns a colored dark mode color scheme where the primary color is based on the provided hue.
    ///
    /// - Parameter hue: The hue value to define the primary color tone.
    /// - Returns: A `ColorScheme` object with properties set for a customizable colored dark mode.
    static func coloredDarkMode(hue: Double) -> ColorScheme {
        ColorScheme(
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
