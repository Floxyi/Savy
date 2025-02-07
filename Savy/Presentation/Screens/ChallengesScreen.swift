//
//  ChallengesScreen.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftData
import SwiftUI

struct ChallengesScreen: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

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
            .background(currentScheme.background)
        }
    }
}

#Preview {
    ChallengesScreen()
        .modelContainer(for: [Challenge.self, ColorService.self])
        .environmentObject(
            ColorServiceViewModel(
                modelContext: ModelContext(
                    try! ModelContainer(for: ColorService.self)
                )
            )
        )
}
