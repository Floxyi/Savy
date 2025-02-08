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
            ChallengeEditScreen(
                challenge: vm.challenge,
                showPopover: $vm.showEditPopover
            )
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
                    removeChallenge: { vm.removeChallenge(dismiss: dismiss) }
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
                CompletionView(removeChallenge: { vm.removeChallenge(dismiss: dismiss) })
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
    let container = try! ModelContainer(
        for: Challenge.self, ColorService.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

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

    return ChallengeDetailScreen(challenge: Challenge(challengeConfiguration: challengeConfiguration))
        .modelContainer(container)
        .environmentObject(
            ColorServiceViewModel(modelContext: ModelContext(container)))
}
