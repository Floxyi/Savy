//
//  ColorServiceViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 07.02.25.
//

import Foundation
import SwiftData

class ColorServiceViewModel: ObservableObject {
    @Published var colorService: ColorService
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        colorService = ColorServiceViewModel.getOrCreateColorManager(in: modelContext)
    }

    static func getOrCreateColorManager(in context: ModelContext) -> ColorService {
        let fetchDescriptor = FetchDescriptor<ColorService>()
        if let existingManager = try? context.fetch(fetchDescriptor).first {
            return existingManager
        } else {
            let newManager = ColorService(hue: 180, currentSchema: ColorSchemes.lightMode())
            context.insert(newManager)
            return newManager
        }
    }
}
