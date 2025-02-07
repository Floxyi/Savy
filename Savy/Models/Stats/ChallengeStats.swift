//
//  ChallengeStats.swift
//  Savy
//
//  Created by Florian Winkler on 12.10.24.
//

import Foundation
import SwiftData

@Model
class ChallengeStats {
    var challengeId: UUID

    init(challengeId: UUID) {
        self.challengeId = challengeId
    }
}
