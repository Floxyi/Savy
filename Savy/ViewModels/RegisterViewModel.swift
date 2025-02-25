//
//  RegisterViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 08.02.25.
//

import SwiftData
import SwiftUI

/// ViewModel for managing the registration process and user input validation.
class RegisterViewModel: ObservableObject {
    /// The username entered by the user.
    @Published var username = ""

    /// Boolean indicating whether the entered username is valid.
    @Published var isUsernameValid = false

    /// Boolean indicating whether there is an error with the entered username.
    @Published var usernameError = true

    /// Boolean indicating whether to show a popup for username input.
    @Published var showUsernamePopup = false

    /// The email entered by the user.
    @Published var email = ""

    /// Boolean indicating whether the entered email is valid.
    @Published var isEmailValid = false

    /// Boolean indicating whether there is an error with the entered email.
    @Published var emailError = true

    /// Boolean indicating whether to show a popup for email input.
    @Published var showEmailPopup = false

    /// The password entered by the user.
    @Published var password = ""

    /// Boolean indicating whether the entered password is valid.
    @Published var isPasswordValid = false

    /// Boolean indicating whether there is an error with the entered password.
    @Published var passwordError = true

    /// Boolean indicating whether to show a popup for password input.
    @Published var showPasswordPopup = false

    /// Indicates whether an authentication error occurred.
    @Published var authError = false

    /// Indicates whether the registration request is loading.
    @Published var isLoading = false

    /// Indicates whether to show a confirmation dialog.
    @Published var showConfirmationDialog = false

    /// A binding to a boolean that tracks if the user is signed in.
    var isSignedIn: Binding<Bool>

    /// Initializes the `RegisterViewModel` with a binding to track sign-in status.
    ///
    /// - Parameter isSignedIn: A `Binding` to track the sign-in status.
    init(isSignedIn: Binding<Bool>) {
        self.isSignedIn = isSignedIn
    }

    /// Validates the username input to ensure it meets length requirements (3-10 characters).
    func validateUsername() {
        isUsernameValid = username.count >= 3 && username.count <= 10
        usernameError = username.isEmpty
    }

    /// Validates the email address format.
    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: email)
        emailError = email.isEmpty
        authError = false
    }

    /// Validates the password length (at least 8 characters).
    func validatePassword() {
        isPasswordValid = password.count >= 8
        passwordError = password.isEmpty
    }

    /// Handles the sign-up button press, validates the input, and performs registration.
    func signUpButtonPressed(statsService: StatsService, challengeService: ChallengeService) {
        isLoading = true
        Task {
            defer { isLoading = false }
            do { isSignedIn.wrappedValue = try await register(statsService: statsService, challengeService: challengeService) } catch { authError = true }
        }
    }

    /// Registers a new user using the provided credentials.
    ///
    /// - Returns: A boolean indicating whether the registration was successful.
    /// - Throws: An error if registration fails.
    private func register(statsService: StatsService, challengeService: ChallengeService) async throws -> Bool {
        try await AuthService.shared.registerWithEmail(username: username, email: email, password: password, statsService: statsService, challengeService: challengeService)
    }
}
