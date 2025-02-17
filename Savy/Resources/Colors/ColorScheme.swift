//
//  ColorScheme.swift
//  Savy
//
//  Created by Florian Winkler on 24.08.24.
//

import SwiftUI

/// A struct that defines a color scheme for the app, including various colors used for different UI components.
///
/// This struct is used to store the colors for different UI elements and the mode (light or dark) for the app.
/// It is also Codable, meaning it can be easily saved or loaded from storage or transferred between systems.
///
/// - `mode`: The color scheme mode (light or dark).
/// - `background`: The background color of the app.
struct ColorScheme: Codable, Equatable {
    /// The mode of the color scheme (light or dark).
    let mode: ColorSchemeMode

    /// The background color for the app's UI.
    let background: Color

    /// The color for the app's navigation bar.
    let bar: Color

    /// The color for icons in the navigation bar.
    let barIcons: Color

    /// The first accent color used in the app's UI.
    let accent1: Color

    /// The second accent color used in the app's UI.
    let accent2: Color

    /// The color used for fonts in the app's UI.
    let font: Color

    /// The coding keys used to encode and decode the `ColorScheme`.
    enum CodingKeys: String, CodingKey {
        case mode, background, bar, barIcons, accent1, accent2, font
    }

    /// Initializes a new color scheme with the provided colors and mode.
    ///
    /// - Parameters:
    ///   - mode: The color scheme mode (light or dark).
    ///   - background: The background color.
    ///   - bar: The color for the navigation bar.
    ///   - barIcons: The color for icons in the navigation bar.
    ///   - accent1: The first accent color.
    ///   - accent2: The second accent color.
    ///   - font: The font color.
    init(mode: ColorSchemeMode, background: Color, bar: Color, barIcons: Color, accent1: Color, accent2: Color, font: Color) {
        self.mode = mode
        self.background = background
        self.bar = bar
        self.barIcons = barIcons
        self.accent1 = accent1
        self.accent2 = accent2
        self.font = font
    }

    /// Initializes a color scheme from a decoder, typically used when decoding from storage or a network response.
    ///
    /// - Parameter decoder: The decoder to read the data from.
    /// - Throws: An error if the decoding process fails.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mode = try container.decode(ColorSchemeMode.self, forKey: .mode)
        background = try Color(hexString: container.decode(String.self, forKey: .background)) ?? .clear
        bar = try Color(hexString: container.decode(String.self, forKey: .bar)) ?? .clear
        barIcons = try Color(hexString: container.decode(String.self, forKey: .barIcons)) ?? .clear
        accent1 = try Color(hexString: container.decode(String.self, forKey: .accent1)) ?? .clear
        accent2 = try Color(hexString: container.decode(String.self, forKey: .accent2)) ?? .clear
        font = try Color(hexString: container.decode(String.self, forKey: .font)) ?? .clear
    }

    /// Encodes the `ColorScheme` to an encoder, typically used when saving to storage or transferring data.
    ///
    /// - Parameter encoder: The encoder to write the data to.
    /// - Throws: An error if the encoding process fails.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mode, forKey: .mode)
        try container.encode(background.hexString, forKey: .background)
        try container.encode(bar.hexString, forKey: .bar)
        try container.encode(barIcons.hexString, forKey: .barIcons)
        try container.encode(accent1.hexString, forKey: .accent1)
        try container.encode(accent2.hexString, forKey: .accent2)
        try container.encode(font.hexString, forKey: .font)
    }
}
