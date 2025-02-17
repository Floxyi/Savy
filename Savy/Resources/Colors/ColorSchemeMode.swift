//
//  ColorSchemeMode.swift
//  Savy
//
//  Created by Florian Winkler on 25.08.24.
//

/// Enum that defines the different modes for the color scheme in the app.
///
/// This enum is used to specify the type of color scheme for the app. The color scheme determines how the app's UI components are styled based on the selected mode.
/// The modes include standard light and dark modes as well as custom "colored" modes.
///
/// - `light`: Represents the standard light mode for the color scheme.
enum ColorSchemeMode: String, Codable {
    /// Light mode where the background is bright and the UI elements use lighter colors.
    case light

    /// Dark mode where the background is dark, and UI elements use darker colors for better contrast in low-light environments.
    case dark

    /// A custom light mode with more vibrant or colorful accent colors.
    case coloredLight

    /// A custom dark mode with more vibrant or colorful accent colors.
    case coloredDark
}
