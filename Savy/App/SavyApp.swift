//
//  SavyApp.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftData
import SwiftUI

@main
struct SavyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ColorService.self, ChallengeService.self, StatsTracker.self, SavingStats.self, StatsEntry.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject private var colorServiceViewModel: ColorServiceViewModel
    @StateObject private var challengeServiceViewModel: ChallengeServiceViewModel

    init() {
        let context = sharedModelContainer.mainContext
        _colorServiceViewModel = StateObject(wrappedValue: ColorServiceViewModel(modelContext: context))
        _challengeServiceViewModel = StateObject(wrappedValue: ChallengeServiceViewModel(modelContext: context))
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(colorServiceViewModel)
                .environmentObject(challengeServiceViewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}
