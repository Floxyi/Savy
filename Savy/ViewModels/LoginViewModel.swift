//
//  LoginViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 08.02.25.
//

import SwiftData
import SwiftUI

class LoginViewModel: ObservableObject {
    @EnvironmentObject private var statsServiceVM: StatsServiceViewModel
    @EnvironmentObject private var challengeServiceVM: ChallengeServiceViewModel

    @Published var email = ""
    @Published var password = ""
    @Published var authError = false
    @Published var isLoading = false
    @Published var showConfirmationDialog = false

    private var isSignedIn: Binding<Bool>

    init(isSignedIn: Binding<Bool>) {
        self.isSignedIn = isSignedIn
    }

    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func validatePassword() -> Bool {
        password.count >= 8
    }

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

    func onShowConfirmationDialogChanged() {
        showConfirmationDialog = true
    }
}
