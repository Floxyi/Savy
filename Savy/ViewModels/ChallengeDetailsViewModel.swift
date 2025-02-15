//
//  ChallengeDetailsViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 08.02.25.
//

import SwiftData
import SwiftUI

class ChallengeDetailsViewModel: ObservableObject {
    @Published var showDetailsPopover = false
    @Published var showEditPopover = false

    private(set) var challenge: Challenge

    init(challenge: Challenge) {
        self.challenge = challenge
    }

    var challengeName: String {
        challenge.challengeConfiguration.name
    }

    var hasRemainingAmount: Bool {
        challenge.remainingAmount() > 0
    }

    var savings: [Saving] {
        challenge.savings
    }

    func editChallenge() {
        showEditPopover = true
    }

    func removeChallenge(dismiss: DismissAction, challengeService: ChallengeService) {
        challengeService.removeChallenge(id: challenge.id)
        dismiss()
        TabBarManager.shared.show()
    }

    func onAppear() {
        TabBarManager.shared.hide()
    }

    func onDismiss(dismiss: DismissAction) {
        dismiss()
        TabBarManager.shared.show()
    }
}
