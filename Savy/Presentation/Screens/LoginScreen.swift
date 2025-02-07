//
//  LoginScreen.swift
//  Savy
//
//  Created by Nadine Schatz on 20.08.24.
//

import SwiftData
import SwiftUI

struct LoginScreen: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    @State private var email = ""
    @State private var password = ""

    @State private var authError = false
    @State private var isLoading = false

    @Binding var isSignedIn: Bool

    @State private var showConfirmationDialog = false

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        let hasLoggedInPreviously = StatsTracker.shared.accountUUID != nil

        VStack {
            HeaderView(title: "Login", dismiss: {
                dismiss()
                TabBarManager.shared.show()
            })
            .padding(.bottom, 88)

            if AuthService.shared.isSignedIn() {
                Text("You are now logged in.")
            }

            if !AuthService.shared.isSignedIn() {
                VStack {
                    LoginTextFieldView(
                        text: $email,
                        placeholder: "someone@example.com",
                        isSecure: false,
                        keyboardType: .emailAddress,
                        contentType: .emailAddress
                    )

                    LoginTextFieldView(
                        text: $password,
                        placeholder: "password",
                        isSecure: true,
                        keyboardType: .default,
                        contentType: .password
                    )

                    Text("The account does not exist or the password is incorrect.")
                        .foregroundStyle(authError ? Color.red : currentSchema.background)
                        .multilineTextAlignment(.center)

                    if hasLoggedInPreviously {
                        ActionButton(
                            content: HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .frame(width: 20, height: 20)
                                } else {
                                    Text("Login")
                                        .font(.system(size: 26))
                                        .fontWeight(.bold)
                                    Image(systemName: "arrow.right")
                                        .fontWeight(.bold)
                                        .font(.system(size: 20))
                                }
                            },
                            isEnabled: !email.isEmpty && !password.isEmpty && !isLoading,
                            action: { showConfirmationDialog = true }
                        )
                        .padding(.top, 72)
                        .confirmationDialog("If you proceed, you will loose all your data when loggin in to a new account.", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                            Button("Bestätigen", role: .destructive) {
                                withAnimation {
                                    signInButtonPressed()
                                }
                            }
                            Button("Abbrechen", role: .cancel) {}
                        }
                    }

                    if !hasLoggedInPreviously {
                        ActionButton(
                            content: HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .frame(width: 20, height: 20)
                                } else {
                                    Text("Login")
                                        .font(.system(size: 26))
                                        .fontWeight(.bold)
                                    Image(systemName: "arrow.right")
                                        .fontWeight(.bold)
                                        .font(.system(size: 20))
                                }
                            },
                            isEnabled: !email.isEmpty && !password.isEmpty && !isLoading,
                            action: signInButtonPressed
                        )
                        .padding(.top, 72)
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
        .background(currentSchema.background)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .onAppear(perform: {
            TabBarManager.shared.hide()
        })
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
        isLoading = true
        authError = false
        Task {
            defer {
                isLoading = false
            }
            do {
                if validateEmail(), validatePassword() {
                    let oldId = StatsTracker.shared.accountUUID
                    let newSignIn = await oldId == nil ? false : try AuthService.shared.signInAsNewAccount(email: email, password: password, oldId: oldId!)
                    isSignedIn = try await AuthService.shared.signInWithEmail(email: email, password: password, sameAccount: newSignIn)
                } else {
                    authError = true
                }
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
            LoginScreen(isSignedIn: $isSignedIn)
        }
    }

    return PreviewWrapper()
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
