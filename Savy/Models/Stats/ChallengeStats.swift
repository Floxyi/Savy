//
//  ChallengeStats.swift
//  Savy
//
//  Created by Florian Winkler on 12.10.24.
//

import Foundation
import SwiftData

/// A model representing statistics for a specific challenge.
///
/// This class is used to store and manage statistics related to a particular challenge,
/// such as tracking the completion of savings or challenge milestones.
///
/// - `challengeId`: A unique identifier for the associated challenge.
@Model
class ChallengeStats {
    /// The unique identifier for the associated challenge.
    var challengeId: UUID

    /// Initializes a new instance of `ChallengeStats` for a specific challenge.
    ///
    /// - Parameter challengeId: The unique identifier of the challenge this stats instance represents.
    init(challengeId: UUID) {
        self.challengeId = challengeId
    }
}
