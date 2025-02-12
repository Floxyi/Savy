//
//  RegisterScreen.swift
//  Savy
//
//  Created by Nadine Schatz on 20.08.24.
//

import SwiftData
import SwiftUI

struct RegisterScreen: View {
    @StateObject private var vm: RegisterViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel
    @EnvironmentObject private var statsServiceVM: StatsServiceViewModel
    @Binding var isSignedIn: Bool

    init(isSignedIn: Binding<Bool>) {
        _vm = StateObject(wrappedValue: RegisterViewModel(isSignedIn: isSignedIn))
        _isSignedIn = isSignedIn
    }

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

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
                        text: $vm.username,
                        isValid: $vm.isUsernameValid,
                        showPopup: $vm.showUsernamePopup,
                        error: $vm.usernameError,
                        placeholder: "username",
                        isSecure: false,
                        validationFunction: vm.validateUsername,
                        popupText: vm.isUsernameValid ? "Valid username." : vm.usernameError ? "Please provide a 5 character username." : "This is not 5 characters long.",
                        keyboardType: .default,
                        contentType: .username
                    )

                    RegistrationTextFieldView(
                        text: $vm.email,
                        isValid: $vm.isEmailValid,
                        showPopup: $vm.showEmailPopup,
                        error: $vm.emailError,
                        placeholder: "someone@example.com",
                        isSecure: false,
                        validationFunction: vm.validateEmail,
                        popupText: vm.isEmailValid ? "Valid email address." : vm.emailError ? "Please provide a valid email address." : "This is not a valid email address.",
                        keyboardType: .emailAddress,
                        contentType: .emailAddress
                    )

                    RegistrationTextFieldView(
                        text: $vm.password,
                        isValid: $vm.isPasswordValid,
                        showPopup: $vm.showPasswordPopup,
                        error: $vm.passwordError,
                        placeholder: "password",
                        isSecure: true,
                        validationFunction: vm.validatePassword,
                        popupText: vm.isPasswordValid ? "Valid password." : vm.passwordError ? "Please provide a 8 character password." : "This password is not 8 characters long.",
                        keyboardType: .default,
                        contentType: .password
                    )

                    Text("This email address is already registered.")
                        .foregroundStyle(vm.authError ? Color.red : currentScheme.background)

                    if statsServiceVM.statsService.accountUUID != nil {
                        ActionButton(
                            content: HStack {
                                if vm.isLoading {
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
                            isEnabled: vm.isUsernameValid && vm.isEmailValid && vm.isPasswordValid && !vm.isLoading,
                            action: { vm.showConfirmationDialog = true }
                        )
                        .padding(.top, 72)
                        .confirmationDialog("If you proceed, you will lose all your personal stats.", isPresented: $vm.showConfirmationDialog, titleVisibility: .visible) {
                            Button("Bestätigen", role: .destructive) {
                                withAnimation {
                                    vm.signUpButtonPressed()
                                }
                            }
                            Button("Abbrechen", role: .cancel) {}
                        }
                    }

                    if statsServiceVM.statsService.accountUUID == nil {
                        ActionButton(
                            content: HStack {
                                if vm.isLoading {
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
                            isEnabled: vm.isUsernameValid && vm.isEmailValid && vm.isPasswordValid && !vm.isLoading,
                            action: vm.signUpButtonPressed
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
        .onAppear {
            TabBarManager.shared.hide()
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
        .environmentObject(StatsServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: StatsService.self))))
}
