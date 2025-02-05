//
//  ChallengeListView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftData
import SwiftUI

struct ChallengesListView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showPopover = false

    var body: some View {
        VStack(alignment: .center) {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(ChallengeManager.shared.sortChallenges()) { challenge in
                    ChallengeListItemView(challenge: challenge)
                }
                ChallengeAddButtonView(showPopover: $showPopover)
            }
        }
        .popover(isPresented: $showPopover) {
            ChallengeAddScreen(showPopover: $showPopover)
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    let challengeConfiguration = ChallengeConfiguration(
        icon: "homepod",
        name: "HomePod",
        amount: 300,
        startDate: Date(),
        strategy: .Monthly,
        calculation: .Amount,
        cycleAmount: 12
    )
    ChallengeManager.shared.addChallenge(challengeConfiguration: challengeConfiguration)

    return ChallengesListView()
        .padding(.top, 80)
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
}
