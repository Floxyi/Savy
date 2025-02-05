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
                ColorManager.self,
            ]
        )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject private var colorManagerVM: ColorManagerViewModel

    init() {
        let context = sharedModelContainer.mainContext
        _colorManagerVM = StateObject(wrappedValue: ColorManagerViewModel(modelContext: context))
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(colorManagerVM)
        }
        .modelContainer(sharedModelContainer)
    }
}
