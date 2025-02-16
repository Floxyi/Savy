//
//  SavingItemView.swift
//  Savy
//
//  Created by Florian Winkler on 05.09.24.
//

import SwiftData
import SwiftUI

struct SavingItemView: View {
    let saving: Saving

    @State private var showConfirmationDialog = false

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel
    @EnvironmentObject private var statsServiceVM: StatsServiceViewModel

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme
        let statsService = statsServiceVM.statsService

        ZStack {
            VStack {
                Text(saving.date.formatted(.dateTime.month(.twoDigits).day(.twoDigits)))
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(currentScheme.font)
                    .frame(width: 50)
                    .padding(4)
                    .background(currentScheme.background)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(.top, 12)
                Spacer()
                Text("$\(NumberFormatterHelper.shared.formatVisibleCurrency(saving.amount))")
                    .font(.system(size: 30, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .foregroundStyle(currentScheme.font)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 2)
                    .padding(.top, -6)
                Spacer()
            }
            .frame(width: 80, height: 80)
            .background(currentScheme.bar)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .opacity(saving.done ? 0.3 : 1)
            .onTapGesture {
                showConfirmationDialog = true
            }
            .confirmationDialog(!saving.done ? "Are you sure you want to mark this saving item ($\(saving.amount)) from the \(saving.date.formatted(.dateTime.month(.twoDigits).day())) as done?" : "Are you sure you want to revert this saving item ($\(saving.amount)) from the \(saving.date.formatted(.dateTime.month(.twoDigits).day()))?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                Button("Confirm", role: .destructive) {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    withAnimation {
                        saving.toggleDone(statsService: statsServiceVM.statsService)
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            if statsService.isSavingLate(saving: saving) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 25, height: 25)
                    .overlay(
                        Text("!")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .offset(x: 30, y: -30)
            }
        }
        .padding(.top, 4)
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
        amount: 500_000,
        startDate: Date(),
        strategy: .Monthly,
        calculation: .Amount,
        cycleAmount: 250_100
    )
    challengeServiceViewModel.challengeService.addChallenge(challengeConfiguration: challengeConfiguration, statsService: statsServiceViewModel.statsService)
    let challenge = challengeServiceViewModel.challengeService.challenges.first!

    return SavingItemView(saving: challenge.savings.first!)
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
        .environmentObject(challengeServiceViewModel)
        .environmentObject(statsServiceViewModel)
}
