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

        VStack {
            Text(saving.date.formatted(.dateTime.month(.twoDigits).day()))
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(currentScheme.font)
                .frame(width: 50)
                .padding(4)
                .background(currentScheme.background)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.bottom, -6)

            Text("\(saving.amount)$")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(currentScheme.font)
        }
        .frame(width: 80, height: 80)
        .background(currentScheme.bar)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(saving.done ? 0.3 : 1)
        .onTapGesture {
            showConfirmationDialog = true
        }
        .confirmationDialog(!saving.done ? "Are you sure you want to mark this saving item (\(saving.amount)$) from the \(saving.date.formatted(.dateTime.month(.twoDigits).day())) as done?" : "Are you sure you want to revert this saving item (\(saving.amount)$) from the \(saving.date.formatted(.dateTime.month(.twoDigits).day()))?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button("Confirm", role: .destructive) {
                withAnimation {
                    saving.toggleDone(statsService: statsServiceVM.statsService)
                }
            }
            Button("Cancel", role: .cancel) {}
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

    return SavingItemView(saving: challenge.savings.first!)
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
        .environmentObject(challengeServiceViewModel)
        .environmentObject(statsServiceViewModel)
}
