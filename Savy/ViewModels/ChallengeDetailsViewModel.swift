//
//  ChallengeDetailsViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 08.02.25.
//

import SwiftData
import SwiftUI

/// ViewModel for managing the state and actions related to the details of a challenge.
class ChallengeDetailsViewModel: ObservableObject {
    /// Controls the visibility of the details popover.
    @Published var showDetailsPopover = false

    /// Controls the visibility of the edit popover.
    @Published var showEditPopover = false

    /// The challenge associated with this view model.
    private(set) var challenge: Challenge

    /// Initializes a new `ChallengeDetailsViewModel` with a given challenge.
    ///
    /// - Parameter challenge: The `Challenge` object whose details are managed.
    init(challenge: Challenge) {
        self.challenge = challenge
    }

    /// The name of the challenge.
    var challengeName: String {
        challenge.challengeConfiguration.name
    }

    /// Boolean indicating whether the challenge has remaining amount to be saved.
    var hasRemainingAmount: Bool {
        challenge.remainingAmount() > 0
    }

    /// The list of savings associated with the challenge.
    var savings: [Saving] {
        challenge.savings
    }

    /// Action to display the edit popover for the challenge.
    func editChallenge() {
        showEditPopover = true
    }

    /// Removes the challenge and dismisses the view.
    ///
    /// - Parameters:
    ///   - dismiss: A closure to dismiss the view after the challenge is removed.
    ///   - challengeService: The `ChallengeService` used to remove the challenge.
    func removeChallenge(dismiss: DismissAction, challengeService: ChallengeService) {
        challengeService.removeChallenge(id: challenge.id)
        dismiss()
        TabBarManager.shared.show()
    }

    /// Hides the tab bar when the view appears.
    func onAppear() {
        TabBarManager.shared.hide()
    }

    /// Shows the tab bar when the view is dismissed.
    ///
    /// - Parameter dismiss: A closure to dismiss the current view.
    func onDismiss(dismiss: DismissAction) {
        dismiss()
        TabBarManager.shared.show()
    }
}
