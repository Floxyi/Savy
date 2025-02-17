//
//  AuthService.swift
//  Savy
//
//  Created by Florian Winkler on 07.02.25.
//

import Foundation
import Supabase

/// A service responsible for authentication and user session management.
///
/// The `AuthService` class handles user sign-up, sign-in, sign-out, and session retrieval.
/// It integrates with Supabase authentication and manages associated profile data.
class AuthService {
    /// The shared singleton instance of `AuthService`.
    static let shared = AuthService()

    /// The Supabase client instance used for authentication requests.
    private let client = SupabaseClientProvider.shared.client

    /// The currently authenticated user's Supabase account information.
    var supabaseAccount: SupabaseAccount?

    /// The currently authenticated user's profile.
    var profile: Profile?

    /// The unique identifier of the authenticated account.
    private(set) var accountUUID: UUID?

    /// Private initializer to enforce the singleton pattern.
    private init() {}

    /// Checks whether a user is currently signed in.
    ///
    /// - Returns: `true` if both `supabaseAccount` and `profile` are not `nil`, otherwise `false`.
    func isSignedIn() -> Bool {
        supabaseAccount != nil && profile != nil
    }

    /// Retrieves the current authentication session from Supabase.
    ///
    /// This method fetches the currently signed-in user's session, retrieves their profile,
    /// and updates the `supabaseAccount` property.
    ///
    /// - Throws: An error if the session retrieval fails.
    func getCurrentSession() async throws {
        let session = try await client.auth.session
        profile = try await ProfileService.shared.getProfile(uuid: session.user.id)
        supabaseAccount = SupabaseAccount(uuid: session.user.id, email: session.user.email)
    }

    /// Registers a new user with an email, username, and password.
    ///
    /// This method creates a new user in Supabase, generates a profile, and initializes the
    /// user's savings and challenge services.
    ///
    /// - Parameters:
    ///   - username: The username for the new account.
    ///   - email: The email address for the new account.
    ///   - password: The password for the new account.
    ///   - statsService: The stats service instance to initialize.
    ///   - challengeService: The challenge service instance to initialize.
    /// - Returns: `true` if the registration and login were successful, otherwise `false`.
    /// - Throws: An error if the registration fails.
    func registerWithEmail(username: String, email: String, password: String, statsService: StatsService, challengeService: ChallengeService) async throws -> Bool {
        let session = try await client.auth.signUp(email: email, password: password)
        profile = try await ProfileService.shared.createProfile(uuid: session.user.id, username: username, statsService: statsService)
        supabaseAccount = SupabaseAccount(uuid: session.user.id, email: session.user.email)
        setAccountUUID(uuid: profile?.id, challengeService: challengeService, statsService: statsService)
        return isSignedIn()
    }

    /// Signs in a user using email and password.
    ///
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The user's password.
    ///   - sameAccount: A flag indicating whether this is the same user account as before.
    ///   - statsService: The stats service instance to initialize.
    ///   - challengeService: The challenge service instance to initialize.
    /// - Returns: `true` if sign-in was successful, otherwise `false`.
    /// - Throws: An error if authentication fails.
    func signInWithEmail(email: String, password: String, sameAccount: Bool, statsService: StatsService, challengeService: ChallengeService) async throws -> Bool {
        let session = try await client.auth.signIn(email: email, password: password)
        profile = try await ProfileService.shared.getProfile(uuid: session.user.id)
        supabaseAccount = SupabaseAccount(uuid: session.user.id, email: session.user.email)
        setAccountUUID(uuid: profile?.id, sameAccount: sameAccount, challengeService: challengeService, statsService: statsService)
        return isSignedIn()
    }

    /// Attempts to sign in with a new account and checks if it differs from the old account.
    ///
    /// - Parameters:
    ///   - email: The email address of the new account.
    ///   - password: The password of the new account.
    ///   - oldId: The UUID of the previously authenticated account.
    /// - Returns: `true` if the new account is different from the old one, otherwise `false`.
    /// - Throws: An error if authentication fails.
    func signInAsNewAccount(email: String, password: String, oldId: UUID) async throws -> Bool {
        let session = try await client.auth.signIn(email: email, password: password)
        let profile = try await ProfileService.shared.getProfile(uuid: session.user.id)
        if profile == nil || profile!.id == oldId { return false }
        return true
    }

    /// Signs out the currently authenticated user.
    ///
    /// - Returns: `true` if sign-out was successful, otherwise `false`.
    /// - Throws: An error if sign-out fails.
    func signOut() async throws -> Bool {
        try await client.auth.signOut()
        profile = nil
        supabaseAccount = nil
        return isSignedIn()
    }

    /// Sets the account UUID and resets user-related data if needed.
    ///
    /// If the user has previously registered and is signing in with the same account,
    /// this method resets the statistics and challenges to ensure a fresh session.
    ///
    /// - Parameters:
    ///   - uuid: The new account UUID.
    ///   - sameAccount: A flag indicating whether this is the same account as before (default is `true`).
    ///   - challengeService: The challenge service instance to manage challenges.
    ///   - statsService: The stats service instance to manage statistics.
    func setAccountUUID(uuid: UUID?, sameAccount: Bool = true, challengeService: ChallengeService, statsService: StatsService) {
        let hasRegisteredBefore = accountUUID != nil
        accountUUID = uuid
        if hasRegisteredBefore, sameAccount {
            statsService.entries.removeAll()
            statsService.updateSavingAmountInDatabase()
            challengeService.removeAllChallenges()
        }
    }
}
