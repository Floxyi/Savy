//
//  SupabaseAccount.swift
//  Savy
//
//  Created by Florian Winkler on 21.09.24.
//

import Foundation

/// Represents a user account in Supabase.
///
/// The `SupabaseAccount` struct stores basic account information, including a unique identifier
/// and an optional email address. This can be used to manage user authentication and profile data.
struct SupabaseAccount {
    /// The unique identifier of the Supabase account.
    let uuid: UUID

    /// The email address associated with the account (optional).
    ///
    /// This can be `nil` if the email is not provided or is hidden for privacy reasons.
    let email: String?
}
