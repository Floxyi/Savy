//
//  ColorManagerViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 04.09.24.
//

import Foundation
import SwiftData

class ColorManagerViewModel: ObservableObject {
    @Published var colorManager: ColorManager
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.colorManager = ColorManagerViewModel.getOrCreateColorManager(in: modelContext)
    }
    
    static func getOrCreateColorManager(in context: ModelContext) -> ColorManager {
        let fetchDescriptor = FetchDescriptor<ColorManager>()
        if let existingManager = try? context.fetch(fetchDescriptor).first {
            return existingManager
        } else {
            let newManager = ColorManager(hue: 180, currentSchema: ColorSchemes.lightMode())
            context.insert(newManager)
            return newManager
        }
    }
}
