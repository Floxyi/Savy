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
        colorService = ColorServiceViewModel.getOrCreateColorService(in: modelContext)
    }

    static func getOrCreateColorService(in context: ModelContext) -> ColorService {
        let fetchDescriptor = FetchDescriptor<ColorService>()
        if let existingService = try? context.fetch(fetchDescriptor).first {
            return existingService
        } else {
            let newService = ColorService(hue: 180, currentScheme: ColorSchemes.lightMode())
            context.insert(newService)
            return newService
        }
    }
}
