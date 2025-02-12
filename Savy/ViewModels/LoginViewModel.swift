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
                    let oldId = statsServiceVM.statsService.accountUUID
                    let newSignIn = await oldId == nil ? false : try AuthService.shared.signInAsNewAccount(email: email, password: password, oldId: oldId!)
                    let signInResult = try await AuthService.shared.signInWithEmail(
                        email: email,
                        password: password,
                        sameAccount: newSignIn,
                        statsService: statsServiceVM.statsService,
                        challengeService: challengeServiceVM.challengeService
                    )
                    self.isSignedIn.wrappedValue = signInResult
                } else {
                    self.authError = true
                }
            } catch {
                self.authError = true
            }
        }
    }

    func onShowConfirmationDialogChanged() {
        showConfirmationDialog = true
    }
}
