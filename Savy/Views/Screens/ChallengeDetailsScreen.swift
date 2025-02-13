//
//  ChallengeDetailsScreen.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftData
import SwiftUI

struct ChallengeDetailScreen: View {
    @StateObject private var vm: ChallengeDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel
    @EnvironmentObject private var challengeServiceVM: ChallengeServiceViewModel

    init(challenge: Challenge) {
        _vm = StateObject(wrappedValue: ChallengeDetailsViewModel(challenge: challenge))
    }

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        return NavigationView {
            VStack {
                headerSection
                challengeInfoSection
                mainContent()
                Spacer()
            }
            .background(currentScheme.background)
        }
        .onAppear(perform: vm.onAppear)
        .padding()
        .background(currentScheme.background)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .popover(isPresented: $vm.showEditPopover) {
            ChallengeEditScreen(challenge: vm.challenge, showPopover: $vm.showEditPopover)
        }
    }

    private var headerSection: some View {
        HeaderView(
            title: vm.challengeName,
            size: 32,
            dismiss: {
                dismiss()
                vm.onDismiss()
            },
            actionView: AnyView(
                ChallengeActionMenu(
                    editChallenge: vm.editChallenge,
                    removeChallenge: { vm.removeChallenge(dismiss: dismiss, challengeService: challengeServiceVM.challengeService) }
                )
            )
        )
        .padding(.bottom, 44)
    }

    private var challengeInfoSection: some View {
        ChallengeInfoView(challenge: vm.challenge)
            .padding(.top, -18)
            .padding(.bottom, 48)
    }

    private func mainContent() -> some View {
        VStack {
            if vm.hasRemainingAmount {
                SavingsGridView(
                    savings: vm.savings, columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
                )
            } else {
                CompletionView(removeChallenge: { vm.removeChallenge(dismiss: dismiss, challengeService: challengeServiceVM.challengeService) })
            }
            Spacer()
            detailsButton
        }
    }

    private var detailsButton: some View {
        ChallengeDetailsButtonView(
            title: "View all",
            icon: "chevron.up",
            showPopover: $vm.showDetailsPopover
        )
        .padding(.bottom, 24)
        .popover(isPresented: $vm.showDetailsPopover) {
            ChallengeDetailsListScreen(
                challenge: vm.challenge,
                showPopover: $vm.showDetailsPopover
            )
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

    return ChallengeDetailScreen(challenge: challenge)
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
        .environmentObject(challengeServiceViewModel)
        .environmentObject(statsServiceViewModel)
}
