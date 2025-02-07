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
                StatsTracker.shared.setAccountUUID(uuid: AuthService.shared.profile?.id)
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: ChallengeManager.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    let challengeConfiguration = ChallengeConfiguration(
        icon: "homepod",
        name: "HomePod",
        amount: 300,
        startDate: Date(),
        strategy: .Monthly,
        calculation: .Amount,
        cycleAmount: 12
    )
    ChallengeManager.shared.addChallenge(challengeConfiguration: challengeConfiguration)

    return AppView()
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
}
