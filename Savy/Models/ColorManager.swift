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
    
    public var currentSchema: ColorScheme {
        get {
            do {
                return try JSONDecoder().decode(ColorScheme.self, from: currentSchemaData)
            } catch {
                return ColorSchemes.lightMode()
            }
        }
        set {
            do {
                currentSchemaData = try JSONEncoder().encode(newValue)
            } catch {
                print("Failed to encode ColorScheme: \(error)")
            }
        }
    }
    
    public init(hue: Double, currentSchema: ColorScheme) {
        self.hue = hue
        do {
            self.currentSchemaData = try JSONEncoder().encode(currentSchema)
        } catch {
            print("Failed to encode initial ColorScheme: \(error)")
            self.currentSchemaData = Data()
        }
    }
    
    func updateSchema(schema: ColorScheme) {
        self.currentSchema = schema
    }
}
