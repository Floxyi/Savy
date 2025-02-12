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

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        challengeService = ChallengeServiceViewModel.getOrCreateChallengeManager(in: modelContext)
    }

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
