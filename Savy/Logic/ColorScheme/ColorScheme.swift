//
//  ColorScheme.swift
//  Savy
//
//  Created by Florian Winkler on 24.08.24.
//

import SwiftUI

struct ColorScheme: Codable, Equatable {
    let mode: ColorSchemeMode
    let background: Color
    let bar: Color
    let barIcons: Color
    let accent1: Color
    let accent2: Color
    let font: Color
    
    enum CodingKeys: String, CodingKey {
        case mode, background, bar, barIcons, accent1, accent2, font
    }
    
    init(mode: ColorSchemeMode, background: Color, bar: Color, barIcons: Color, accent1: Color, accent2: Color, font: Color) {
        self.mode = mode
        self.background = background
        self.bar = bar
        self.barIcons = barIcons
        self.accent1 = accent1
        self.accent2 = accent2
        self.font = font
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mode = try container.decode(ColorSchemeMode.self, forKey: .mode)
        background = Color(hexString: try container.decode(String.self, forKey: .background)) ?? .clear
        bar = Color(hexString: try container.decode(String.self, forKey: .bar)) ?? .clear
        barIcons = Color(hexString: try container.decode(String.self, forKey: .barIcons)) ?? .clear
        accent1 = Color(hexString: try container.decode(String.self, forKey: .accent1)) ?? .clear
        accent2 = Color(hexString: try container.decode(String.self, forKey: .accent2)) ?? .clear
        font = Color(hexString: try container.decode(String.self, forKey: .font)) ?? .clear
    }
    
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
