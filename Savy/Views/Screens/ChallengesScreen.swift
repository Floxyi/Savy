//
//  ChallengesScreen.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftData
import SwiftUI

struct ChallengesScreen: View {
    @State private var selectedChallengeId: String?
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel
    @EnvironmentObject private var challengeServiceVM: ChallengeServiceViewModel

    var body: some View {
        NavigationStack {
            VStack {
                HeaderView(title: String(localized: "Challenges"))
                ChallengesListView()
                HStack {
                    Spacer()
                }
            }
            .padding(.top)
            .padding(.bottom, 112)
            .background(colorServiceVM.colorService.currentScheme.background)
            .navigationDestination(isPresented: Binding(
                get: { selectedChallengeId != nil },
                set: { if !$0 { selectedChallengeId = nil } }
            )) {
                destinationView()
            }
        }
        .onAppear {
            NotificationService.shared.observeNotificationTap { challengeId in
                selectedChallengeId = challengeId
            }
        }
    }

    private func destinationView() -> ChallengeDetailScreen? {
        guard let challengeId = selectedChallengeId, let uuid = UUID(uuidString: challengeId),
              let challenge = challengeServiceVM.challengeService.getChallengeById(id: uuid)
        else {
            return nil
        }
        return ChallengeDetailScreen(challenge: challenge)
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
    challengeServiceViewModel.challengeService.addChallenge(
        challengeConfiguration: challengeConfiguration,
        statsService: statsServiceViewModel.statsService
    )

    return ChallengesScreen()
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
        .environmentObject(challengeServiceViewModel)
        .environmentObject(statsServiceViewModel)
}
