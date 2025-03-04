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
    static let sharedModelContainer: ModelContainer = Self.createModelContainer()

    @StateObject private var colorServiceViewModel: ColorServiceViewModel
    @StateObject private var challengeServiceViewModel: ChallengeServiceViewModel
    @StateObject private var statsServiceViewModel: StatsServiceViewModel

    @StateObject private var notificationService = NotificationService.shared
    @StateObject private var challengeRouterService = ChallengeRouterService.shared

    init() {
        let context = Self.sharedModelContainer.mainContext
        _colorServiceViewModel = StateObject(wrappedValue: ColorServiceViewModel(modelContext: context))
        _challengeServiceViewModel = StateObject(wrappedValue: ChallengeServiceViewModel(modelContext: context))
        _statsServiceViewModel = StateObject(wrappedValue: StatsServiceViewModel(modelContext: context))

        if AppEnvironment.current == .development {
            let dataHelper = DataHelper(challengeService: challengeServiceViewModel.challengeService, statsService: statsServiceViewModel.statsService)
            dataHelper.loadData()
        }
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(colorServiceViewModel)
                .environmentObject(challengeServiceViewModel)
                .environmentObject(statsServiceViewModel)
                .onAppear {
                    notificationService.requestStartPermission()
                    NotificationService.shared.observeNotificationTap { challengeId in
                        ChallengeRouterService.shared.navigateToChallenge(with: challengeId)
                    }
                }
        }
        .modelContainer(Self.sharedModelContainer)
    }

    private static func createModelContainer() -> ModelContainer {
        let schema = Schema([ColorService.self, ChallengeService.self, StatsService.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
