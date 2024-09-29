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
        .onAppear {
            Task {
                try await AuthManager.shared.getCurrentSession()
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let endDate = Calendar.current.date(byAdding: .month, value: 24, to: Date())!
    container.mainContext.insert(Challenge(name: "HomePod", icon: "homepod", startDate: Date(), endDate: endDate, targetAmount: 300, strategy: .Monthly))
    container.mainContext.insert(Challenge(name: "AirPods", icon: "airpods.gen3", startDate: Date(), endDate: endDate, targetAmount: 280, strategy: .Monthly))
    
    return AppView()
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
        .environmentObject(TabBarManager())
}
e
