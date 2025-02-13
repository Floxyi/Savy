//
//  ChallengeDetailsListViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 08.02.25.
//

import SwiftData
import SwiftUI

class ChallengeDetailsListViewModel: ObservableObject {
    @Published var sortedSavings: [Saving]

    private(set) var challenge: Challenge

    init(challenge: Challenge) {
        sortedSavings = challenge.savings.sorted { $0.date < $1.date }
        self.challenge = challenge
    }
}
