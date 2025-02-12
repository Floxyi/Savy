//
//  AuthService.swift
//  Savy
//
//  Created by Florian Winkler on 07.02.25.
//

import Foundation
import Supabase

class AuthService {
    static let shared = AuthService()

    private let client = SupabaseClientProvider.shared.client
    var supabaseAccount: SupabaseAccount?
    var profile: Profile?

    private init() {}

    func isSignedIn() -> Bool {
        supabaseAccount != nil && profile != nil
    }

    func getCurrentSession() async throws {
        let session = try await client.auth.session
        profile = try await ProfileService.shared.getProfile(uuid: session.user.id)
        supabaseAccount = SupabaseAccount(uuid: session.user.id, email: session.user.email)
    }

    func registerWithEmail(username: String, email: String, password: String, statsService: StatsService, challengeService: ChallengeService) async throws -> Bool {
        let session = try await client.auth.signUp(email: email, password: password)
        profile = try await ProfileService.shared.createProfile(uuid: session.user.id, username: username, statsService: statsService)
        supabaseAccount = SupabaseAccount(uuid: session.user.id, email: session.user.email)
        statsService.setAccountUUID(uuid: profile?.id, challengeService: challengeService)
        return isSignedIn()
    }

    func signInWithEmail(email: String, password: String, sameAccount: Bool, statsService: StatsService, challengeService: ChallengeService) async throws -> Bool {
        let session = try await client.auth.signIn(email: email, password: password)
        profile = try await ProfileService.shared.getProfile(uuid: session.user.id)
        supabaseAccount = SupabaseAccount(uuid: session.user.id, email: session.user.email)
        statsService.setAccountUUID(uuid: profile?.id, sameAccount: sameAccount, challengeService: challengeService)
        return isSignedIn()
    }

    func signInAsNewAccount(email: String, password: String, oldId: UUID) async throws -> Bool {
        let session = try await client.auth.signIn(email: email, password: password)
        let profile = try await ProfileService.shared.getProfile(uuid: session.user.id)

        if profile == nil {
            return false
        }

        if profile!.id == oldId {
            return false
        }

        return true
    }

    func signOut() async throws -> Bool {
        try await client.auth.signOut()
        profile = nil
        supabaseAccount = nil
        return isSignedIn()
    }
}
