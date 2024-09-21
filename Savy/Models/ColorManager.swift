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
