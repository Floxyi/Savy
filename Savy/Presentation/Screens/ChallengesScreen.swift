//
//  ChallengesScreen.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftData
import SwiftUI

struct ChallengesScreen: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    @Query private var challenges: [Challenge]
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(title: "Challenges")
                ChallengesListView(challenges: challenges)
            }
            .padding(.top, 14)
            .padding(.bottom, 112)
            .background(colorManagerVM.colorManager.currentSchema.background)
        }
    }
}

#Preview {
    ChallengesScreen()
        .modelContainer(for: [Challenge.self, ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
