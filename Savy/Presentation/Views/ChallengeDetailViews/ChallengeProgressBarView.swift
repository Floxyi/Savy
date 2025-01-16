//
//  ProgressBar.swift
//  Savy
//
//  Created by Florian Winkler on 25.09.24.
//

import SwiftData
import SwiftUI

struct ChallengeProgressBarView: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    let challenge: Challenge

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        let progress = CGFloat(challenge.progressPercentage())

        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(currentSchema.accent1)
                    .frame(height: geometry.size.height)

                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(currentSchema.barIcons)
                    .frame(width: geometry.size.width * progress, height: geometry.size.height)

                HStack {
                    Image(systemName: challenge.challengeConfiguration.icon)
                        .foregroundColor(currentSchema.accent2)

                    Spacer()

                    Text("\(challenge.currentSavedAmount())€")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(currentSchema.accent2)

                    Spacer()

                    Text("\(challenge.challengeConfiguration.amount)€")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(currentSchema.accent2)
                }
                .padding(.horizontal, 10)
            }
        }
        .frame(height: 30)
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

    return ChallengeProgressBarView(challenge: Challenge(challengeConfiguration: challengeConfiguration))
        .padding()
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
}
