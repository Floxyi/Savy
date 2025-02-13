//
//  StatsServiceViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 12.02.25.
//

import Foundation
import SwiftData

class StatsServiceViewModel: ObservableObject {
    @Published var statsService: StatsService
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        statsService = StatsServiceViewModel.getOrCreateStatsService(in: modelContext)
    }

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
