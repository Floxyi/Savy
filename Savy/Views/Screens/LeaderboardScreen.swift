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
        .background(colorServiceVM.colorService.currentScheme.background)
    }
}

#Preview {
    LeaderboardScreen()
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
