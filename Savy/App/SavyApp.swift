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
        let colorServiceVM = ColorServiceViewModel(modelContext: context)
        let challengeServiceVM = ChallengeServiceViewModel(modelContext: context)
        let statsServiceVM = StatsServiceViewModel(modelContext: context)

        _colorServiceViewModel = StateObject(wrappedValue: colorServiceVM)
        _challengeServiceViewModel = StateObject(wrappedValue: challengeServiceVM)
        _statsServiceViewModel = StateObject(wrappedValue: statsServiceVM)

        if AppEnvironment.current == .development {
            let dataHelper = DataHelper(challengeService: challengeServiceVM.challengeService, statsService: statsServiceVM.statsService)
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
