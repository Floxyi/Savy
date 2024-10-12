//
//  LeaderboardScreen.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftData
import SwiftUI

struct LeaderboardScreen: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    @State var users: [Profile] = []
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            HeaderView(title: "Leaderboard")
            Text(StatsTracker.shared.totalMoneySaved().description)
            HStack {
                List(users) { user in
                    Text(user.username ?? "Unknown")
                }
                .scrollContentBackground(.hidden)
                .overlay {
                    if users.isEmpty {
                        ProgressView()
                    }
                }
                .task {
                    do {
                        users = try await AuthManager.shared.client.from("profiles").select().execute().value
                    } catch {
                        dump(error)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .background(currentSchema.background)
    }
}

#Preview {
    LeaderboardScreen()
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
