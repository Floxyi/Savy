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

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        NavigationView {
            VStack {
                HeaderView(title: "Challenges")
                ChallengesListView()
                HStack {
                    Spacer()
                }
            }
            .padding(.top)
            .padding(.bottom, 112)
            .background(currentSchema.background)
        }
    }
}

#Preview {
    ChallengesScreen()
        .modelContainer(for: [Challenge.self, ColorManager.self])
        .environmentObject(
            ColorManagerViewModel(
                modelContext: ModelContext(
                    try! ModelContainer(for: ColorManager.self)
                )
            )
        )
}
