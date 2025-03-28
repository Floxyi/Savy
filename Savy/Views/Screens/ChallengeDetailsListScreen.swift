//
//  ChallengeDetailsListScreen.swift
//  Savy
//
//  Created by Florian Winkler on 11.10.24.
//

import SwiftData
import SwiftUI

struct ChallengeDetailsListScreen: View {
    @Binding var showPopover: Bool
    @StateObject private var vm: ChallengeDetailsListViewModel
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    init(challenge: Challenge, showPopover: Binding<Bool>) {
        _vm = StateObject(wrappedValue: ChallengeDetailsListViewModel(challenge: challenge))
        _showPopover = showPopover
    }

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        NavigationStack {
            VStack {
                ChallengeDetailsButtonView(title: String(localized: "Hide"), icon: "chevron.down", showPopover: $showPopover)
                    .padding(.top, -36)
                    .padding(.bottom, 4)

                HeaderView(title: String(localized: "Savings Overview"), fontSize: 38)
                    .padding(.bottom, -1)

                HStack {
                    Text("Start:")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(currentScheme.font)
                    Text(vm.challenge.challengeConfiguration.startDate.formatted(.dateTime.day().month().year()))
                        .font(.system(size: 16))
                        .foregroundColor(currentScheme.font)
                    Spacer()
                    Text("End:")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(currentScheme.font)
                    Text(vm.challenge.challengeConfiguration.endDate.formatted(.dateTime.day().month().year()))
                        .font(.system(size: 16))
                        .foregroundColor(currentScheme.font)
                }
                .padding(.horizontal, 20)
                .padding(.top, 1)

                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                        ForEach(vm.sortedSavings, id: \.id) { saving in
                            SavingItemView(saving: saving)
                        }
                    }
                }
                .padding(.top, 20)
                .background(currentScheme.background)

                Spacer()
                HStack {
                    Spacer()
                }
            }
            .padding()
            .background(currentScheme.background)
        }
    }
}

#Preview {
    @Previewable @State var showPopover = true

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

    return Spacer()
        .popover(isPresented: $showPopover) {
            ChallengeDetailsListScreen(challenge: challenge, showPopover: $showPopover)
        }
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
        .environmentObject(challengeServiceViewModel)
        .environmentObject(statsServiceViewModel)
}
