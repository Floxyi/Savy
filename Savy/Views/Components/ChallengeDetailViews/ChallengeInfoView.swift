//
//  ChallengeInfoView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftData
import SwiftUI

struct ChallengeInfoView: View {
    let challenge: Challenge

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel
    @EnvironmentObject private var challengeServiceVM: ChallengeServiceViewModel
    @EnvironmentObject private var statsServiceViewModel: StatsServiceViewModel

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme
        let challengeService = challengeServiceVM.challengeService
        let statsService = statsServiceViewModel.statsService

        VStack {
            VStack {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(currentScheme.accent2)
                    Text("Start: \(challenge.challengeConfiguration.startDate.formatted(.dateTime.year().month(.twoDigits).day(.twoDigits)))")
                        .font(.system(size: 14))
                        .foregroundStyle(currentScheme.font)
                    Spacer()
                    Image(systemName: "calendar.badge.checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(currentScheme.accent2)
                    Text("End: \(challenge.challengeConfiguration.endDate.formatted(.dateTime.year().month(.twoDigits).day(.twoDigits)))")
                        .font(.system(size: 14))
                        .foregroundStyle(currentScheme.font)
                }

                ChallengeProgressBarView(challenge: challenge)

                HStack {
                    HStack(alignment: .center) {
                        Image(systemName: "flame")
                            .font(.system(size: 10))
                            .foregroundStyle(currentScheme.font)
                        Text("Current Streak: \(statsService.getCurrentStreak(challengeId: challenge.id, challengeService: challengeService))")
                            .font(.system(size: 12))
                            .foregroundStyle(currentScheme.font)
                            .padding(.leading, -4)
                    }
                    Spacer()
                    Text("\(challenge.remainingSavings()) savings left")
                        .font(.system(size: 12))
                        .foregroundStyle(currentScheme.font)
                }
                .padding(.top, 2)
            }
            .padding(16)
            .background(currentScheme.bar)
            .clipShape(RoundedRectangle(cornerRadius: 18))
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
    let challenge = challengeServiceViewModel.challengeService.challenges.first!

    return ChallengeInfoView(challenge: challenge)
        .padding()
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
        .environmentObject(challengeServiceViewModel)
        .environmentObject(statsServiceViewModel)
}
