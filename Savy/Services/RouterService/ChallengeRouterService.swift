//
//  ChallengeRouterService.swift
//  Savy
//
//  Created by Florian Winkler on 15.02.25.
//

import Foundation

/// A router class responsible for managing the navigation state for challenges in the app.
class ChallengeRouterService: ObservableObject {
    /// The current path of navigation, represented as an array of `String` identifiers.
    /// The path stores the sequence of challenge identifiers the app navigates through.
    @Published var path = [String]()

    /// Shared instance of `ChallengeRouter` for global access.
    static let shared = ChallengeRouterService()

    /// Private initializer to prevent initialization from outside the class.
    private init() {}

    /// Navigates to the detail view of a specific challenge by updating the navigation path with the provided challenge ID.
    ///
    /// This function is typically used to navigate to a challenge's detailed screen by passing the unique challenge identifier.
    ///
    /// - Parameter challengeID: A `String` representing the unique identifier of the challenge to navigate to.
    func navigateToChallenge(with challengeID: String) {
        path = [challengeID]
    }
}
