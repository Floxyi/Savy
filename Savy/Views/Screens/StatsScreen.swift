//
//  StatsScreen.swift
//  Savy
//
//  Created by Nadine Schatz on 25.02.25.
//

import SwiftData
import SwiftUI

struct StatsScreen: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel
    @State private var selectedPage = 0

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        VStack {
            TabView(selection: $selectedPage) {
                FirstView().tag(0)
                SecondView().tag(1)
                ThirdView().tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            PageIndicatorView(numberOfPages: 3, currentPage: selectedPage)
                .environmentObject(colorServiceVM)
                .padding(.bottom, 92)
        }
        .background(currentScheme.background)
    }
}

#Preview {
    let schema = Schema([ChallengeService.self, ColorService.self, StatsService.self])
    let container = try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext

    let colorServiceViewModel = ColorServiceViewModel(modelContext: context)
    let challengeServiceViewModel = ChallengeServiceViewModel(modelContext: context)
    let statsServiceViewModel = StatsServiceViewModel(modelContext: context)

    let statsService = statsServiceViewModel.statsService

    let challengeConfiguration = ChallengeConfiguration(
        icon: "homepod",
        name: "HomePod",
        amount: 300,
        startDate: Date(),
        strategy: .Monthly,
        calculation: .Amount,
        cycleAmount: 12
    )
    challengeServiceViewModel.challengeService.addChallenge(challengeConfiguration: challengeConfiguration, statsService: statsService)

    statsService.addChallengeCompletedStatsEntry(challengeId: UUID())
    statsService.addMoneySavedStatsEntry(savingId: UUID(), amount: 20, date: Date())
    statsService.addMoneySavedStatsEntry(savingId: UUID(), amount: 50, date: Date())
    statsService.addMoneySavedStatsEntry(savingId: UUID(), amount: 20, date: Date())
    statsService.addChallengeStartedStatsEntry(challengeId: UUID())
    statsService.addChallengeStartedStatsEntry(challengeId: UUID())

    return StatsScreen()
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
        .environmentObject(challengeServiceViewModel)
        .environmentObject(statsServiceViewModel)
}
