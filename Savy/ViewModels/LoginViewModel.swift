//
//  LoginViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 08.02.25.
//

import SwiftData
import SwiftUI

/// ViewModel for managing the login state and actions.
class LoginViewModel: ObservableObject {
    /// The `StatsServiceViewModel` injected into the environment.
    @EnvironmentObject private var statsServiceVM: StatsServiceViewModel

    /// The `ChallengeServiceViewModel` injected into the environment.
    @EnvironmentObject private var challengeServiceVM: ChallengeServiceViewModel

    /// The email entered by the user.
    @Published var email = ""

    /// The password entered by the user.
    @Published var password = ""

    /// Indicates whether an authentication error occurred.
    @Published var authError = false

    /// Indicates whether the login request is loading.
    @Published var isLoading = false

    /// Indicates whether to show a confirmation dialog.
    @Published var showConfirmationDialog = false

    /// A binding to a boolean that tracks if the user is signed in.
    private var isSignedIn: Binding<Bool>

    /// Initializes the `LoginViewModel` with a binding to track sign-in status.
    ///
    /// - Parameter isSignedIn: A `Binding` to track the sign-in status.
    init(isSignedIn: Binding<Bool>) {
        self.isSignedIn = isSignedIn
    }

    /// Validates the email address format.
    ///
    /// - Returns: `true` if the email is valid, otherwise `false`.
    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    /// Validates the password length.
    ///
    /// - Returns: `true` if the password is at least 8 characters long, otherwise `false`.
    func validatePassword() -> Bool {
        password.count >= 8
    }

    /// Handles the sign-in button press and performs login validation and sign-in.
    func signInButtonPressed() {
        DispatchQueue.main.async {
            self.isLoading = true
        }

        authError = false
        Task { @MainActor in
            defer {
                self.isLoading = false
            }

            do {
                if validateEmail(), validatePassword() {
                    self.isSignedIn.wrappedValue = try await signIn()
                } else {
                    self.authError = true
                }
            } catch {
                self.authError = true
            }
        }
    }

    /// Performs the sign-in process by interacting with the authentication service.
    ///
    /// - Returns: A boolean indicating whether the sign-in was successful.
    /// - Throws: An error if sign-in fails.
    private func signIn() async throws -> Bool {
        let statsService = statsServiceVM.statsService
        let challengeService = challengeServiceVM.challengeService
        let authService = AuthService.shared
        let oldId = authService.accountUUID
        let isSameAccount = oldId == nil ? false : try await authService.signInAsNewAccount(
            email: email,
            password: password,
            oldId: oldId!
        )
        return try await authService.signInWithEmail(
            email: email,
            password: password,
            sameAccount: isSameAccount,
            statsService: statsService,
            challengeService: challengeService
        )
    }

    /// Changes the state to show the confirmation dialog.
    func onShowConfirmationDialogChanged() {
        showConfirmationDialog = true
    }
}
