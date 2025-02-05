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

    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        VStack {
            VStack {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(currentSchema.accent2)
                    Text("Start: \(challenge.challengeConfiguration.startDate.formatted(.dateTime.year().month(.twoDigits).day()))")
                        .font(.system(size: 14))
                        .foregroundStyle(currentSchema.font)
                    Spacer()
                    Image(systemName: "calendar.badge.checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(currentSchema.accent2)
                    Text("End: \(challenge.savings.last!.date.formatted(.dateTime.year().month(.twoDigits).day()))")
                        .font(.system(size: 14))
                        .foregroundStyle(currentSchema.font)
                }

                ChallengeProgressBarView(challenge: challenge)

                HStack {
                    Spacer()
                    Text("\(challenge.remainingSavings()) savings to go")
                        .font(.system(size: 12))
                        .foregroundStyle(currentSchema.font)
                }
            }
            .padding(16)
            .background(currentSchema.bar)
            .clipShape(RoundedRectangle(cornerRadius: 18))
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

    return ChallengeInfoView(challenge: Challenge(challengeConfiguration: challengeConfiguration))
        .padding()
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
}
