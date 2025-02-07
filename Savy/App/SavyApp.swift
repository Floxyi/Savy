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
        let schema = Schema(
            [
                ChallengeManager.self,
                StatsTracker.self,
                SavingStats.self,
                StatsEntry.self,
                ColorService.self,
            ]
        )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject private var colorServiceViewModel: ColorServiceViewModel

    init() {
        let context = sharedModelContainer.mainContext
        _colorServiceViewModel = StateObject(wrappedValue: ColorServiceViewModel(modelContext: context))
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(colorServiceViewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}
