//
//  RegisterScreen.swift
//  Savy
//
//  Created by Nadine Schatz on 20.08.24.
//

import SwiftData
import SwiftUI

struct RegisterScreen: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    @State private var username = ""
    @State private var isUsernameValid = false
    @State private var usernameError = true
    @State private var showUsernamePopup = false

    @State private var email = ""
    @State private var isEmailValid = false
    @State private var emailError = true
    @State private var showEmailPopup = false

    @State private var password = ""
    @State private var isPasswordValid = false
    @State private var passwordError = true
    @State private var showPasswordPopup = false

    @State private var authError = false
    @State private var isLoading = false

    @Binding var isSignedIn: Bool

    @State private var showConfirmationDialog = false

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme
        let hasRegestiredPreviously = StatsTracker.shared.accountUUID != nil

        VStack {
            HeaderView(title: "Register", dismiss: {
                dismiss()
                TabBarManager.shared.show()
            })
            .padding(.bottom, 88)

            if AuthService.shared.isSignedIn() {
                Text("You are now registered.")
            }

            if !AuthService.shared.isSignedIn() {
                VStack {
                    RegistrationTextFieldView(
                        text: $username,
                        isValid: $isUsernameValid,
                        showPopup: $showUsernamePopup,
                        error: $usernameError,
                        placeholder: "username",
                        isSecure: false,
                        validationFunction: validateuUsername,
                        popupText: isUsernameValid ? "Valid username." : usernameError ? "Please provide a 5 character username." : "This is not 5 characters long.",
                        keyboardType: .default,
                        contentType: .username
                    )

                    RegistrationTextFieldView(
                        text: $email,
                        isValid: $isEmailValid,
                        showPopup: $showEmailPopup,
                        error: $emailError,
                        placeholder: "someone@example.com",
                        isSecure: false,
                        validationFunction: validateEmail,
                        popupText: isEmailValid ? "Valid email address." : emailError ? "Please provide a valid email address." : "This is not a valid email address.",
                        keyboardType: .emailAddress,
                        contentType: .emailAddress
                    )

                    RegistrationTextFieldView(
                        text: $password,
                        isValid: $isPasswordValid,
                        showPopup: $showPasswordPopup,
                        error: $passwordError,
                        placeholder: "password",
                        isSecure: true,
                        validationFunction: validatePassword,
                        popupText: isPasswordValid ? "Valid password." : passwordError ? "Please provide a 8 character password." : "This password is not 8 characters long.",
                        keyboardType: .default,
                        contentType: .password
                    )

                    Text("This email address is already registered.")
                        .foregroundStyle(authError ? Color.red : currentScheme.background)

                    if hasRegestiredPreviously {
                        ActionButton(
                            content: HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .frame(width: 20, height: 20)
                                } else {
                                    Text("Register")
                                        .font(.system(size: 26))
                                        .fontWeight(.bold)
                                    Image(systemName: "arrow.right")
                                        .fontWeight(.bold)
                                        .font(.system(size: 20))
                                }
                            },
                            isEnabled: isUsernameValid && isEmailValid && isPasswordValid && !isLoading,
                            action: { showConfirmationDialog = true }
                        )
                        .padding(.top, 72)
                        .confirmationDialog("If you proceed, you will loose all your personal stats.", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                            Button("Bestätigen", role: .destructive) {
                                withAnimation {
                                    signUpButtonPressed()
                                }
                            }
                            Button("Abbrechen", role: .cancel) {}
                        }
                    }

                    if !hasRegestiredPreviously {
                        ActionButton(
                            content: HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .frame(width: 20, height: 20)
                                } else {
                                    Text("Register")
                                        .font(.system(size: 26))
                                        .fontWeight(.bold)
                                    Image(systemName: "arrow.right")
                                        .fontWeight(.bold)
                                        .font(.system(size: 20))
                                }
                            },
                            isEnabled: isUsernameValid && isEmailValid && isPasswordValid && !isLoading,
                            action: signUpButtonPressed
                        )
                    }
                }
            }

            Spacer()
            HStack {
                Spacer()
            }
        }
        .padding(.top, 92)
        .padding(.bottom, 112)
        .background(currentScheme.background)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .onAppear(perform: {
            TabBarManager.shared.hide()
        })
    }

    func validateuUsername() {
        isUsernameValid = username.count >= 5
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
            defer {
                isLoading = false
            }
            do {
                isSignedIn = try await AuthService.shared.registerWithEmail(username: username, email: email, password: password)
            } catch {
                authError = true
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isSignedIn: Bool = false

        var body: some View {
            RegisterScreen(isSignedIn: $isSignedIn)
        }
    }

    return PreviewWrapper()
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
