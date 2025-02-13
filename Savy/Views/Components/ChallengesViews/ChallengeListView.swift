//
//  ChallengeListView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftData
import SwiftUI

struct ChallengesListView: View {
    @State private var showPopover = false
    @EnvironmentObject private var challengeServiceVM: ChallengeServiceViewModel

    var body: some View {
        VStack(alignment: .center) {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(challengeServiceVM.challengeService.sortChallenges()) { challenge in
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
    let schema = Schema([ChallengeService.self, ColorService.self, StatsService.self])
    let container = try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext

    let colorServiceViewModel = ColorServiceViewModel(modelContext: context)
    let challengeServiceViewModel = ChallengeServiceViewModel(modelContext: context)
    let statsServiceViewModel = StatsServiceViewModel(modelContext: context)

    let challengeConfiguration = ChallengeConfiguration(
        icon: "homepod",
        name: "HomePod",
        amount: 300,
        startDate: Date(),
        strategy: .Monthly,
        calculation: .Amount,
        cycleAmount: 12
    )
    challengeServiceViewModel.challengeService.addChallenge(challengeConfiguration: challengeConfiguration, statsService: statsServiceViewModel.statsService)

    return ChallengesListView()
        .padding(.top, 80)
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
        .environmentObject(challengeServiceViewModel)
        .environmentObject(statsServiceViewModel)
}
