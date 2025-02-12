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

    public init(hue: Double, currentScheme: ColorScheme) {
        self.hue = hue
        do {
            currentSchemeData = try JSONEncoder().encode(currentScheme)
        } catch {
            print("Failed to encode initial ColorScheme: \(error)")
            currentSchemeData = Data()
        }
    }

    func updateScheme(schema: ColorScheme) {
        currentScheme = schema
    }
}
