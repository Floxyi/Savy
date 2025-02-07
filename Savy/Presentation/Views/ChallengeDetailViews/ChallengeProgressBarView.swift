//
//  ChallengeProgressBarView.swift
//  Savy
//
//  Created by Florian Winkler on 25.09.24.
//

import SwiftData
import SwiftUI

struct ChallengeProgressBarView: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    let challenge: Challenge

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme
        let progress = CGFloat(challenge.progressPercentage())

        GeometryReader { geometry in
            ZStack {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: geometry.size.height / 2)
                        .fill(currentScheme.accent1)
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height
                        )

                    Rectangle()
                        .fill(currentScheme.barIcons)
                        .frame(
                            width: geometry.size.width * progress,
                            height: geometry.size.height
                        )
                }
                .mask(
                    RoundedRectangle(cornerRadius: geometry.size.height / 2)
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height
                        )
                )

                HStack {
                    Image(systemName: challenge.challengeConfiguration.icon)
                        .foregroundColor(currentScheme.accent2)

                    Spacer()

                    Text("\(challenge.currentSavedAmount())€")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(currentScheme.accent2)

                    Spacer()

                    Text("\(challenge.challengeConfiguration.amount)€")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(currentScheme.accent2)
                }
                .padding(.horizontal, 10)
            }
        }
        .frame(height: 30)
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Challenge.self, ColorService.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let challengeConfiguration = ChallengeConfiguration(
        icon: "homepod",
        name: "HomePod",
        amount: 1000,
        startDate: Date(),
        strategy: .Monthly,
        calculation: .Amount,
        cycleAmount: 12
    )

    let challenge = Challenge(challengeConfiguration: challengeConfiguration)
    challenge.getNextSaving(at: 1).toggleDone()

    ChallengeManager.shared.addChallenge(
        challengeConfiguration: challengeConfiguration
    )

    return ChallengeProgressBarView(challenge: challenge)
        .padding()
        .modelContainer(container)
        .environmentObject(
            ColorServiceViewModel(modelContext: ModelContext(container)))
}
