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
    
    @State var users: [User] = []
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            HeaderView(title: "Leaderboard")
            HStack {
                List(users) { user in
                  Text(user.name)
                }
                .scrollContentBackground(.hidden)
                .overlay {
                  if users.isEmpty {
                    ProgressView()
                  }
                }
                .task {
                  do {
                      users = try await supabase.from("users").select().execute().value
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
