//
//  TabBarView.swift
//  Savy
//
//  Created by Florian Winkler on 25.08.24.
//

import SwiftUI

enum Tab: String, Hashable, CaseIterable {
    case challenges = "calendar"
    case leaderboard = "trophy"
    case settings = "gear"
}

struct ContentView: View {

    init() {
        UITabBar.appearance().isHidden = true
    }
    
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
            
            BottomTabBarView(currentTab: $selectedTab)
                .padding(.bottom)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Challenge.self, ColorManager.self])
}
