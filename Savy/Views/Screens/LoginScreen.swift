//
//  LoginScreen.swift
//  Savy
//
//  Created by Nadine Schatz on 20.08.24.
//

import SwiftData
import SwiftUI

struct LoginScreen: View {
    @Binding var isSignedIn: Bool
    @StateObject private var vm: LoginViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    init(isSignedIn: Binding<Bool>) {
        _vm = StateObject(wrappedValue: LoginViewModel(isSignedIn: isSignedIn))
        _isSignedIn = isSignedIn
    }

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        VStack {
            HeaderView(title: String(localized: "Login"), dismiss: {
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
                        text: $vm.email,
                        placeholder: String(localized: "someone@example.com"),
                        isSecure: false,
                        keyboardType: .emailAddress,
                        contentType: .emailAddress
                    )

                    LoginTextFieldView(
                        text: $vm.password,
                        placeholder: String(localized: "password"),
                        isSecure: true,
                        keyboardType: .default,
                        contentType: .password
                    )

                    Text("The account does not exist or the password is incorrect.")
                        .foregroundStyle(vm.authError ? Color.red : currentScheme.background)
                        .multilineTextAlignment(.center)

                    if AuthService.shared.accountUUID != nil {
                        ActionButton(
                            content: HStack {
                                if vm.isLoading {
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
                            isEnabled: !vm.email.isEmpty && !vm.password.isEmpty && !vm.isLoading,
                            action: { vm.onShowConfirmationDialogChanged() }
                        )
                        .padding(.top, 72)
                        .confirmationDialog("If you proceed, you will lose all your data when logging in to a new account.", isPresented: $vm.showConfirmationDialog, titleVisibility: .visible) {
                            Button("Confirm", role: .destructive) {
                                withAnimation {
                                    vm.signInButtonPressed()
                                }
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                    }

                    if AuthService.shared.accountUUID == nil {
                        ActionButton(
                            content: HStack {
                                if vm.isLoading {
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
                            isEnabled: !vm.email.isEmpty && !vm.password.isEmpty && !vm.isLoading,
                            action: vm.signInButtonPressed
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
        .background(currentScheme.background)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .onAppear(perform: {
            TabBarManager.shared.hide()
        })
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
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
        .environmentObject(StatsServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: StatsService.self))))
}
