//
//  RegisterViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 08.02.25.
//

import SwiftData
import SwiftUI

class RegisterViewModel: ObservableObject {
    @EnvironmentObject private var statsServiceVM: StatsServiceViewModel
    @EnvironmentObject private var challengeServiceVM: ChallengeServiceViewModel

    @Published var username = ""
    @Published var isUsernameValid = false
    @Published var usernameError = true
    @Published var showUsernamePopup = false

    @Published var email = ""
    @Published var isEmailValid = false
    @Published var emailError = true
    @Published var showEmailPopup = false

    @Published var password = ""
    @Published var isPasswordValid = false
    @Published var passwordError = true
    @Published var showPasswordPopup = false

    @Published var authError = false
    @Published var isLoading = false
    @Published var showConfirmationDialog = false

    var isSignedIn: Binding<Bool>

    init(isSignedIn: Binding<Bool>) {
        self.isSignedIn = isSignedIn
    }

    func validateUsername() {
        isUsernameValid = username.count >= 3 && username.count <= 10
        usernameError = username.isEmpty
    }

    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: email)
        emailError = email.isEmpty
        authError = false
    }

    func validatePassword() {
        isPasswordValid = password.count >= 8
        passwordError = password.isEmpty
    }

    func signUpButtonPressed() {
        isLoading = true
        Task {
            defer { isLoading = false }
            do { isSignedIn.wrappedValue = try await register() } catch { authError = true }
        }
    }

    private func register() async throws -> Bool {
        try await AuthService.shared.registerWithEmail(
            username: username,
            email: email,
            password: password,
            statsService: statsServiceVM.statsService,
            challengeService: challengeServiceVM.challengeService
        )
    }
}
