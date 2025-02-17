//
//  ChallengeServiceViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 12.02.25.
//

import Foundation
import SwiftData

class ChallengeServiceViewModel: ObservableObject {
    @Published var challengeService: ChallengeService
    private var modelContext: ModelContext

    /// Initializes a new `ChallengeServiceViewModel` instance.
    ///
    /// This initializer creates a `ChallengeServiceViewModel` with the provided `ModelContext` and fetches or creates the `ChallengeService` associated with it.
    /// - Parameter modelContext: The `ModelContext` used for fetching or creating the `ChallengeService`.
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        challengeService = ChallengeServiceViewModel.getOrCreateChallengeManager(in: modelContext)
    }

    /// Fetches an existing `ChallengeService` or creates a new one if none exists.
    ///
    /// This method attempts to fetch an existing `ChallengeService` from the given `ModelContext`. If no existing service is found, a new `ChallengeService` is created and inserted into the context.
    /// - Parameter context: The `ModelContext` used for fetching or inserting the `ChallengeService`.
    /// - Returns: The `ChallengeService` object, either fetched or newly created.
    static func getOrCreateChallengeManager(in context: ModelContext) -> ChallengeService {
        let fetchDescriptor = FetchDescriptor<ChallengeService>()
        if let existingService = try? context.fetch(fetchDescriptor).first {
            return existingService
        } else {
            let newService = ChallengeService()
            context.insert(newService)
            return newService
        }
    }
}
