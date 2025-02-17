//
//  ProfileService.swift
//  Savy
//
//  Created by Florian Winkler on 07.02.25.
//

import Foundation
import Supabase

/// A service responsible for managing user profiles in Supabase.
///
/// The `ProfileService` class provides methods for creating, retrieving, and managing
/// user profiles and associated savings data. It interacts with the Supabase database.
class ProfileService {
    /// The shared singleton instance of `ProfileService`.
    static let shared = ProfileService()

    /// The Supabase client instance used for database interactions.
    private let client = SupabaseClientProvider.shared.client

    /// Private initializer to enforce the singleton pattern.
    private init() {}

    /// Creates a new user profile and initializes savings in the database.
    ///
    /// This method inserts a new profile and savings record into Supabase.
    /// The savings amount is initialized based on the user's total saved money.
    ///
    /// - Parameters:
    ///   - uuid: The unique identifier of the new profile.
    ///   - username: The username associated with the profile.
    ///   - statsService: The stats service instance used to retrieve the total saved money.
    /// - Returns: The created `Profile` object.
    /// - Throws: An error if the database insertion fails.
    func createProfile(uuid: UUID, username: String, statsService: StatsService) async throws -> Profile {
        let profileEntry = Profile(id: uuid, username: username)
        let savingsEntry = Savings(profileId: uuid, amount: statsService.totalMoneySaved())

        try await client.from("profiles").insert(profileEntry).execute()
        try await client.from("savings").insert(savingsEntry).execute()

        return profileEntry
    }

    /// Retrieves a user profile from the database by UUID.
    ///
    /// - Parameter uuid: The unique identifier of the profile.
    /// - Returns: The `Profile` object if found, otherwise `nil`.
    /// - Throws: An error if the database query fails.
    func getProfile(uuid: UUID) async throws -> Profile? {
        try await client
            .from("profiles")
            .select()
            .eq("uuid", value: uuid)
            .single()
            .execute()
            .value
    }

    /// Fetches all user profiles from the database.
    ///
    /// - Returns: An array of `Profile` objects.
    /// - Throws: An error if the database query fails.
    func getAllProfiles() async throws -> [Profile] {
        try await client
            .from("profiles")
            .select()
            .execute()
            .value
    }

    /// Retrieves a user profile along with their savings amount.
    ///
    /// This method fetches the profile and the total savings amount in a single query.
    ///
    /// - Parameter uuid: The unique identifier of the profile.
    /// - Returns: A `ProfileWithSavings` object containing profile data and savings amount.
    /// - Throws: An error if the database query fails.
    func getProfileWithAmount(uuid: UUID) async throws -> ProfileWithSavings {
        try await client
            .from("profiles")
            .select("id, username, savings(amount)")
            .eq("uuid", value: uuid)
            .single()
            .execute()
            .value
    }

    /// Fetches all user profiles along with their associated savings data.
    ///
    /// - Returns: An array of `ProfileWithSavings` objects.
    /// - Throws: An error if the database query fails.
    func getAllProfilesWithSavings() async throws -> [ProfileWithSavings] {
        try await client
            .from("profiles")
            .select("uuid, username, savings(profile_id, amount)")
            .execute()
            .value
    }
}
