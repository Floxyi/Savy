//
//  LeaderboardScreen.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftData
import SwiftUI

struct LeaderboardScreen: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    @State var showsPersonalStats: Bool = false

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        VStack {
            if showsPersonalStats {
                PersonalStatsView()
            }

            if !showsPersonalStats {
                LeaderboardView()
            }

            Spacer()

            LeaderboardSwitchButton(showsPersonalStats: $showsPersonalStats)
                .padding(.bottom, 100)

            HStack {
                Spacer()
            }
        }
        .padding()
        .background(currentScheme.background)
    }
}

#Preview {
    LeaderboardScreen()
        .modelContainer(for: [ColorService.self])
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
