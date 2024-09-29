//
//  AuthManager.swift
//  Savy
//
//  Created by Florian Winkler on 21.09.24.
//

import Foundation
import Supabase

class AuthManager {
    static let shared = AuthManager()
    
    let client: SupabaseClient
    var supabaseAccount: SupabaseAccount?
    var profile: Profile?
    
    private init() {
        let (url, key) = AppEnvironment.current == .production
        ? (DotEnv.PROD_SUPABASE_URL, DotEnv.PROD_SUPABASE_ANON_KEY)
        : (DotEnv.DEV_SUPABASE_URL, DotEnv.DEV_SUPABASE_ANON_KEY)
        self.client = SupabaseClient(supabaseURL: URL(string: url)!, supabaseKey: key)
        self.supabaseAccount = nil
        self.profile = nil
    }
    
    func isSignedIn() -> Bool {
        return supabaseAccount != nil && profile != nil
    }
    
    func getCurrentSession() async throws {
        let session = try await client.auth.session
        self.profile = try await getProfile(uuid: session.user.id)
        self.supabaseAccount = SupabaseAccount(uuid: session.user.id, email: session.user.email)
    }
    
    func registerWithEmail(username: String, email: String, password: String) async throws -> Bool {
        let session = try await client.auth.signUp(email: email, password: password)
        self.profile = try await createProfile(uuid: session.user.id, username: username)
        self.supabaseAccount = SupabaseAccount(uuid: session.user.id, email: session.user.email)
        return isSignedIn()
    }
    
    func signInWithEmail(email: String, password: String) async throws -> Bool {
        let session = try await client.auth.signIn(email: email, password: password)
        self.profile = try await getProfile(uuid: session.user.id)
        self.supabaseAccount = SupabaseAccount(uuid: session.user.id, email: session.user.email)
        return isSignedIn()
    }
    
    func signOut() async throws -> Bool {
        try await client.auth.signOut()
        self.profile = nil
        self.supabaseAccount = nil
        return isSignedIn()
    }
    
    func getProfile(uuid: UUID) async throws -> Profile? {
        return try await client.from("profiles").select().eq("uuid", value: uuid).single().execute().value
    }
    
    func createProfile(uuid: UUID, username: String) async throws -> Profile {
        let profile = Profile(id: uuid, username: username)
        try await client.from("profiles").insert(profile).eq("uuid", value: uuid).execute()
        return profile
    }
}
