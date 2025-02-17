//
//  ChallengeDetailsListViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 08.02.25.
//

import SwiftData
import SwiftUI

/// ViewModel for managing and displaying a list of savings for a given challenge.
class ChallengeDetailsListViewModel: ObservableObject {
    /// The list of savings for the challenge, sorted by date.
    @Published var sortedSavings: [Saving]

    /// The challenge associated with this view model.
    private(set) var challenge: Challenge

    /// Initializes a new `ChallengeDetailsListViewModel` with a given challenge.
    ///
    /// - Parameter challenge: The `Challenge` object whose savings will be managed.
    init(challenge: Challenge) {
        // Sorts the savings for the challenge by date in ascending order
        sortedSavings = challenge.savings.sorted { $0.date < $1.date }
        self.challenge = challenge
    }
}
