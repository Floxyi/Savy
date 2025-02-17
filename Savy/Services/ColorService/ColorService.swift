//
//  ColorService.swift
//  Savy
//
//  Created by Florian Winkler on 24.08.24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class ColorService {
    public var hue: Double
    public var currentSchemeData: Data

    /// The current color scheme, decoded from `currentSchemeData`.
    ///
    /// This computed property decodes the `currentSchemeData` into a `ColorScheme`. If decoding fails, it returns the default light mode color scheme.
    /// - Returns: The current `ColorScheme` object.
    public var currentScheme: ColorScheme {
        get {
            do {
                return try JSONDecoder().decode(ColorScheme.self, from: currentSchemeData)
            } catch {
                return ColorSchemes.lightMode()
            }
        }
        set {
            do {
                currentSchemeData = try JSONEncoder().encode(newValue)
            } catch {
                print("Failed to encode ColorScheme: \(error)")
            }
        }
    }

    /// Initializes a new `ColorService` instance with a specified hue and color scheme.
    ///
    /// This initializer takes a hue and a `ColorScheme`, and attempts to encode the `ColorScheme` into `currentSchemeData`.
    /// - Parameters:
    ///   - hue: The hue value for the color scheme.
    ///   - currentScheme: The initial `ColorScheme` object to be encoded.
    public init(hue: Double, currentScheme: ColorScheme) {
        self.hue = hue
        do {
            currentSchemeData = try JSONEncoder().encode(currentScheme)
        } catch {
            print("Failed to encode initial ColorScheme: \(error)")
            currentSchemeData = Data()
        }
    }

    /// Updates the current color scheme with the provided `ColorScheme`.
    ///
    /// This method updates the `currentScheme` property by encoding the provided `ColorScheme` into `currentSchemeData`.
    /// - Parameter schema: The new `ColorScheme` to be set.
    func updateScheme(schema: ColorScheme) {
        currentScheme = schema
    }
}
