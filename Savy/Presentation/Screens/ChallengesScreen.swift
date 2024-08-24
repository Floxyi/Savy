//
//  ChallengesView.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftUI
import SwiftData

struct ChallengesScreen: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var challenges: [Challenge]
    
    var body: some View {
        NavigationView {
            TabView {
                VStack {
                    HeaderView(title: "Challenges")
                    ChallengesListView(challenges: challenges)
                }
                .padding()
                .tabItem {
                    Label("Challenges", systemImage: "calendar")
                }
                
                LeaderboardScreen()
                    .tabItem {
                        Label("Leaderboard", systemImage: "trophy")
                    }
                
                SettingsScreen()
                    .tabItem {
                        Label("Account", systemImage: "person.crop.circle")
                    }
            }
        }
    }
}

#Preview {
    ChallengesScreen()
        .modelContainer(for: [Challenge.self])
}
