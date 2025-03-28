//
//  ChallengeListItemView.swift
//  Savy
//
//  Created by Florian Winkler on 03.09.24.
//

import SwiftData
import SwiftUI

struct ChallengeListItemView: View {
    let challenge: Challenge
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        NavigationLink(destination: ChallengeDetailScreen(challenge: challenge)) {
            VStack(spacing: 12) {
                HeadlineView(challenge: challenge)
                ProgressView(challenge: challenge)
            }
            .padding(16)
            .background(colorServiceVM.colorService.currentScheme.bar)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .listRowBackground(Color(.secondarySystemBackground))
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
}

private struct HeadlineView: View {
    let challenge: Challenge
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        HStack {
            IconAndNameView(challenge: challenge)
            Spacer()
            DateView(date: challenge.challengeConfiguration.endDate)
        }
    }
}

private struct IconAndNameView: View {
    let challenge: Challenge
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        HStack {
            Image(systemName: challenge.challengeConfiguration.icon)
                .fontWeight(.bold)
            Text(challenge.challengeConfiguration.name)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
        }
        .foregroundStyle(colorServiceVM.colorService.currentScheme.accent2)
    }
}

private struct DateView: View {
    let date: Date
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        HStack {
            Text(date.formatted(.dateTime.month(.twoDigits).day().year()))
            Image(systemName: "calendar.badge.checkmark")
        }
        .font(.system(size: 13, weight: .bold))
        .foregroundStyle(colorServiceVM.colorService.currentScheme.accent2)
    }
}

private struct ProgressView: View {
    let challenge: Challenge
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        HStack {
            if challenge.remainingSavings() != 0 {
                SavingsProgressView(challenge: challenge)
            } else {
                FinishedView()
            }
            Spacer()
            VStack {
                Spacer()
                AmountView(challenge: challenge)
            }
        }
        .frame(height: 50)
    }
}

private struct SavingsProgressView: View {
    let challenge: Challenge
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        let next1Saving = challenge.getNextSaving(at: 1) ?? challenge.getLastSaving()
        let next2Saving = challenge.getNextSaving(at: 2) ?? challenge.getLastSaving()
        let next3Saving = challenge.getNextSaving(at: 3) ?? challenge.getLastSaving()

        HStack(spacing: -8) {
            NextSavingView(saving: next1Saving, isNext: true)

            if challenge.remainingSavings() >= 2 {
                Divider()
                    .frame(width: 16, height: 2)
                    .background(colorServiceVM.colorService.currentScheme.font)
                    .padding(.horizontal, 8)
                NextSavingView(saving: next2Saving, isNext: false)
            }

            if challenge.remainingSavings() == 3 {
                Divider()
                    .frame(width: 16, height: 2)
                    .background(colorServiceVM.colorService.currentScheme.font)
                    .padding(.horizontal, 8)
                NextSavingView(saving: next3Saving, isNext: false)
            }

            if challenge.remainingSavings() != 3 {
                Divider()
                    .frame(width: 16, height: 2)
                    .background(colorServiceVM.colorService.currentScheme.font)
                    .padding(.horizontal, 8)
                RemainingView(remainingSavings: challenge.remainingSavings())
            }
        }
    }
}

private struct NextSavingView: View {
    let saving: Saving
    let isNext: Bool
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        VStack {
            Text("$\(NumberFormatterHelper.shared.formatCurrency(saving.amount))")
                .font(.system(size: 16, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.1)
            Text(saving.date.formatted(.dateTime.month(.twoDigits).day()))
                .font(.system(size: 12))
        }
        .frame(width: 42, height: 42)
        .padding(4)
        .background(
            isNext ? colorServiceVM.colorService.currentScheme.font : .clear
        )
        .foregroundStyle(
            isNext
                ? colorServiceVM.colorService.currentScheme.background
                : colorServiceVM.colorService.currentScheme.font
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 2))
                .foregroundColor(colorServiceVM.colorService.currentScheme.font)
                .opacity(isNext ? 0 : 1)
        )
    }
}

private struct RemainingView: View {
    let remainingSavings: Int
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        VStack {
            if remainingSavings > 2 {
                Text("\((remainingSavings - 2).description)x")
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                Text("left")
            } else {
                Image(systemName: "flag.2.crossed")
                Text("Done")
            }
        }
        .font(.system(size: 14))
        .frame(width: 42, height: 42)
        .padding(6)
        .foregroundStyle(colorServiceVM.colorService.currentScheme.font)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                .foregroundColor(colorServiceVM.colorService.currentScheme.font)
        )
    }
}

private struct FinishedView: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        HStack {
            Image(systemName: "flag.pattern.checkered.2.crossed")
            Text("Finished!")
            Image(systemName: "flag.pattern.checkered.2.crossed")
        }
        .font(.system(size: 18))
        .foregroundStyle(colorServiceVM.colorService.currentScheme.font)
    }
}

private struct AmountView: View {
    let challenge: Challenge
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        let progress = CGFloat(challenge.progressPercentage())

        ZStack {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorServiceVM.colorService.currentScheme.accent1)
                    .frame(width: 110, height: 30)

                Rectangle()
                    .fill(colorServiceVM.colorService.currentScheme.barIcons)
                    .frame(width: 110 * progress, height: 30)
            }
            .mask(
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 110, height: 30)
            )

            HStack(alignment: .bottom, spacing: -4) {
                Text("$\(NumberFormatterHelper.shared.formatCurrency(challenge.currentSavedAmount()))")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(colorServiceVM.colorService.currentScheme.font)
                    .padding(.trailing, 7)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                Text("/ $\(NumberFormatterHelper.shared.formatCurrency(challenge.challengeConfiguration.amount))")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(colorServiceVM.colorService.currentScheme.accent2)
                    .offset(y: -3)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        .frame(height: 30)
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

    return ChallengeListItemView(challenge: challenge)
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
        .environmentObject(challengeServiceViewModel)
        .environmentObject(statsServiceViewModel)
}
