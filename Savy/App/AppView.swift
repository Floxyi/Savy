//
//  AppView.swift
//  Savy
//
//  Created by Florian Winkler on 25.08.24.
//

import SwiftData
import SwiftUI

struct AppView: View {
    @ObservedObject private var tabBarManager = TabBarManager.shared
    @EnvironmentObject private var statsServiceVM: StatsServiceViewModel
    @EnvironmentObject private var challengeServiceVM: ChallengeServiceViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $tabBarManager.selectedTab) {
                ChallengesScreen()
                    .tag(Tab.challenges)

                LeaderboardScreen()
                    .tag(Tab.leaderboard)

                SettingsScreen()
                    .tag(Tab.settings)
            }
            .onAppear {
                UITabBar.appearance().isHidden = true
            }

            if tabBarManager.isShown {
                BottomTabBarView(currentTab: $tabBarManager.selectedTab)
                    .padding(.bottom)
            }
        }
        .onAppear {
            Task {
                try await AuthService.shared.getCurrentSession()
                statsServiceVM.statsService.setAccountUUID(uuid: AuthService.shared.profile?.id, challengeService: challengeServiceVM.challengeService)
            }
        }
    }
}

#Preview {
    let schema = Schema([ChallengeService.self, ColorService.self, StatsService.self])
    let container = try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext

    let colorServiceViewModel = ColorServiceViewModel(modelContext: context)
    let challengeServiceViewModel = ChallengeServiceViewModel(modelContext: context)
    let statsServiceViewModel = StatsServiceViewModel(modelContext: context)

    let challengeConfiguration = ChallengeConfiguration(
        icon: "homepod",
        name: "HomePod",
        amount: 300,
        startDate: Date(),
        strategy: .Monthly,
        calculation: .Amount,
        cycleAmount: 12
    )
    challengeServiceViewModel.challengeService.addChallenge(challengeConfiguration: challengeConfiguration, statsService: statsServiceViewModel.statsService)

    return AppView()
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
        .environmentObject(challengeServiceViewModel)
        .environmentObject(statsServiceViewModel)
}
