//
//  ColorManager.swift
//  Savy
//
//  Created by Florian Winkler on 24.08.24.
//

import SwiftData
import SwiftUI

@Model
class ColorManager {
    public var hue: Double
    public var currentSchemaData: Data
    
    public var currentSchema: ColorSchema {
        get {
            do {
                return try JSONDecoder().decode(ColorSchema.self, from: currentSchemaData)
            } catch {
                return ColorSchemes.lightMode()
            }
        }
        set {
            do {
                currentSchemaData = try JSONEncoder().encode(newValue)
            } catch {
                print("Failed to encode ColorSchema: \(error)")
            }
        }
    }
    
    public init(hue: Double, currentSchema: ColorSchema) {
        self.hue = hue
        do {
            self.currentSchemaData = try JSONEncoder().encode(currentSchema)
        } catch {
            print("Failed to encode initial ColorSchema: \(error)")
            self.currentSchemaData = Data()
        }
    }
    
    func updateSchema(schema: ColorSchema) {
        self.currentSchema = schema
    }
}

enum ColorSchemesEnum: String, Codable {
    case light, dark, coloredLight, coloredDark
}

struct ColorSchemes {
    static func lightMode() -> ColorSchema {
        return ColorSchema(
            mode: .light,
            background: Color(hue: 0, saturation: 0, lightness: 95),
            bar: Color(hue: 0, saturation: 0, lightness: 84),
            barIcons: Color(hue: 0, saturation: 0, lightness: 67),
            accent1: Color(hue: 0, saturation: 0, lightness: 75),
            accent2: Color(hue: 0, saturation: 0, lightness: 36),
            font: Color(hue: 0, saturation: 0, lightness: 45)
        )
    }
    
    static func darkMode() -> ColorSchema {
        return ColorSchema(
            mode: .dark,
            background: Color(hue: 0, saturation: 0, lightness: 22),
            bar: Color(hue: 0, saturation: 0, lightness: 20),
            barIcons: Color(hue: 0, saturation: 0, lightness: 42),
            accent1: Color(hue: 0, saturation: 0, lightness: 31),
            accent2: Color(hue: 0, saturation: 0, lightness: 80),
            font: Color(hue: 0, saturation: 0, lightness: 100)
        )
    }
    
    static func coloredLightMode(hue: Double) -> ColorSchema {
        return ColorSchema(
            mode: .coloredLight,
            background: Color(hue: hue, saturation: 27, lightness: 45),
            bar: Color(hue: hue, saturation: 30, lightness: 33),
            barIcons: Color(hue: hue, saturation: 41, lightness: 81),
            accent1: Color(hue: hue, saturation: 26, lightness: 40),
            accent2: Color(hue: hue, saturation: 41, lightness: 68),
            font: Color(hue: hue, saturation: 62, lightness: 93)
        )
    }
    
    static func coloredDarkMode(hue: Double) -> ColorSchema {
        return ColorSchema(
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
