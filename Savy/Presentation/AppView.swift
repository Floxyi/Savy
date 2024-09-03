//
//  AppView.swift
//  Savy
//
//  Created by Florian Winkler on 25.08.24.
//

import SwiftData
import SwiftUI

enum Tab: String, Hashable, CaseIterable {
    case challenges = "calendar"
    case leaderboard = "trophy"
    case settings = "gear"
}

struct AppView: View {
    @Query private var challenges: [Challenge]
    
    @EnvironmentObject private var tabBarManager: TabBarManager
    
    @State private var selectedTab: Tab = Tab.challenges
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                ChallengesScreen()
                    .tag(Tab.challenges)
                
                LeaderboardScreen()
                    .tag(Tab.leaderboard)
                
                SettingsScreen()
                    .tag(Tab.settings)
            }
            .onAppear(perform: {
                UITabBar.appearance().isHidden = true
            })
            
            if tabBarManager.isOn {
                BottomTabBarView(currentTab: $selectedTab)
                    .padding(.bottom)
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    container.mainContext.insert(Challenge(name: "MacBook", icon: "macbook", startDate: Date(), endDate: Date(), targetAmount: 1500))

    return AppView()
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
        .environmentObject(TabBarManager())
}
