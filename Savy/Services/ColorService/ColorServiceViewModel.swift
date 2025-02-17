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

    /// Initializes a new `ColorServiceViewModel` with a specified `ModelContext`.
    ///
    /// This initializer takes a `ModelContext`, retrieves or creates a `ColorService` object, and binds it to the view model.
    /// - Parameters:
    ///   - modelContext: The `ModelContext` used to fetch or create the `ColorService`.
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        colorService = ColorServiceViewModel.getOrCreateColorService(in: modelContext)
    }

    /// Retrieves an existing `ColorService` from the `ModelContext` or creates a new one if none exists.
    ///
    /// This method checks for an existing `ColorService` in the provided `ModelContext`. If none is found, it creates a new `ColorService` with default values.
    /// - Parameter context: The `ModelContext` in which to fetch or create the `ColorService`.
    /// - Returns: An existing or newly created `ColorService` object.
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
