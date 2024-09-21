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
    
    private init() {
        let (url, key) = AppEnvironment.current == .production
        ? (DotEnv.PROD_SUPABASE_URL, DotEnv.PROD_SUPABASE_ANON_KEY)
        : (DotEnv.DEV_SUPABASE_URL, DotEnv.DEV_SUPABASE_ANON_KEY)
        
        self.client = SupabaseClient(supabaseURL: URL(string: url)!, supabaseKey: key)
    }
    
    func getCurrentSession() async throws -> AppUser? {
        let session = try await client.auth.session
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    func registerWithEmail(email: String, password: String) async throws -> AppUser {
        let session = try await client.auth.signUp(email: email, password: password)
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    func signInWithEmail(email: String, password: String) async throws -> AppUser {
        let session = try await client.auth.signIn(email: email, password: password)
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    func signOut() async throws -> AppUser? {
        try await client.auth.signOut()
        return try await getCurrentSession()
    }
}
