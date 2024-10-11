//
//  AppView.swift
//  Savy
//
//  Created by Florian Winkler on 25.08.24.
//

import SwiftData
import SwiftUI

struct AppView: View {
    @Query private var challenges: [Challenge]
    
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
                try await AuthManager.shared.getCurrentSession()
            }
        }
    }
}

#Preview("Filled") {
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let endDate = Calendar.current.date(byAdding: .month, value: 24, to: Date())!
    container.mainContext.insert(Challenge(
        name: "HomePod",
        icon: "homepod",
        startDate: Date(),
        endDate: endDate,
        targetAmount: 300,
        strategy: .Monthly,
        calculation: .Amount,
        savingAmount: 12
    ))
    container.mainContext.insert(Challenge(
        name: "AirPods",
        icon: "airpods.gen3",
        startDate: Date(),
        endDate: endDate,
        targetAmount: 250,
        strategy: .Monthly,
        calculation: .Date
    ))
    
    return AppView()
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
}
