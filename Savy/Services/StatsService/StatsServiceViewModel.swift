//
//  StatsServiceViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 12.02.25.
//

import Foundation
import SwiftData

/// A view model responsible for managing and providing access to `StatsService` in a `ModelContext`.
///
/// This class is an `ObservableObject` that exposes the `StatsService` instance and provides methods for fetching or creating the service in a given model context.
/// It is used to handle statistics-related functionality for the app, such as tracking money saved, challenges completed, and other relevant metrics.
class StatsServiceViewModel: ObservableObject {
    /// The `StatsService` instance that manages statistics entries.
    @Published var statsService: StatsService

    /// The `ModelContext` used for data operations.
    private var modelContext: ModelContext

    /// Initializes the `StatsServiceViewModel` with a `ModelContext` and fetches or creates the associated `StatsService`.
    ///
    /// - Parameter modelContext: The `ModelContext` used for fetching or creating the `StatsService`.
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        statsService = StatsServiceViewModel.getOrCreateStatsService(in: modelContext)
    }

    /// Fetches an existing `StatsService` from the given `ModelContext` or creates a new one if none exists.
    ///
    /// - Parameter context: The `ModelContext` to fetch the `StatsService` from.
    /// - Returns: The existing or newly created `StatsService`.
    static func getOrCreateStatsService(in context: ModelContext) -> StatsService {
        let fetchDescriptor = FetchDescriptor<StatsService>()
        if let existingService = try? context.fetch(fetchDescriptor).first {
            return existingService
        } else {
            let newService = StatsService()
            context.insert(newService)
            return newService
        }
    }
}
