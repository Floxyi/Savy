//
//  SavingStats 2.swift
//  Savy
//
//  Created by Florian Winkler on 12.10.24.
//


import Foundation
import SwiftData

// Saves the ID for a challenge in stats entry so you can use the ID to find a specific challenge.
@Model
class ChallengeStats {
    var challengeId: UUID
    
    init(challengeId: UUID) {
        self.challengeId = challengeId
    }
}
