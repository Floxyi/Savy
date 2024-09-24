//
//  LoginScreen.swift
//  Savy
//
//  Created by Nadine Schatz on 20.08.24.
//

import SwiftData
import SwiftUI

struct RegisterScreen: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    @EnvironmentObject private var tabBarManager: TabBarManager
    
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
    
    @Binding var appUser: AppUser?
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            HeaderView(title: "Register", dismiss: {
                dismiss()
                tabBarManager.show()
            })
            .padding(.bottom, 88)
            
            if appUser != nil {
                Text("You are now registered.")
            }
            
            if appUser == nil {
                VStack {
                    AccountTextFieldView(
                        text: $email,
                        isValid: $isEmailValid,
                        showPopup: $showEmailPopup,
                        error: $emailError,
                        placeholder: "someone@example.com",
                        isSecure: false,
                        validationFunction: validateEmail,
                        popupText: isEmailValid ? "Valid email address." : emailError ? "Please provide a valid email address." : "This is not a valid email address."
                    )
                    
                    AccountTextFieldView(
                        text: $password,
                        isValid: $isPasswordValid,
                        showPopup: $showPasswordPopup,
                        error: $passwordError,
                        placeholder: "password",
                        isSecure: true,
                        validationFunction: validatePassword,
                        popupText: isPasswordValid ? "Valid password." : passwordError ? "Please provide a 8 character password." : "This password is not 8 characters long."
                    )
                    
                    Text("This email address is already registered.")
                        .foregroundStyle(authError ? Color.red : currentSchema.background)
                    
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
                        isEnabled: isEmailValid && isPasswordValid && !isLoading,
                        action: signUpButtonTapped
                    )
                    .padding(.top, 72)
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
            tabBarManager.hide()
        })
    }
    
    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: email)
        emailError = email.isEmpty
        authError = false
    }
    
    func validatePassword() {
        isPasswordValid = password.count >= 8
        passwordError = password.isEmpty
    }
    
    func signUpButtonTapped() {
        isLoading = true
        
        Task {
            defer {
                isLoading = false
            }
            
            do {
                let appUser = try await AuthManager.shared.registerWithEmail(email: email, password: password)
                self.appUser = appUser
            } catch {
                authError = true
            }
        }
    }
}

#Preview("Logged Out") {
    struct PreviewWrapper: View {
        @State private var dummyUser: AppUser? = nil
        
        var body: some View {
            RegisterScreen(appUser: $dummyUser)
        }
    }
    
    return PreviewWrapper()
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
        .environmentObject(TabBarManager())
}

#Preview("Logged In") {
    struct PreviewWrapper: View {
        @State private var dummyUser: AppUser? = AppUser(uid: "123", email: "preview@example.com")
        
        var body: some View {
            RegisterScreen(appUser: $dummyUser)
        }
    }
    
    return PreviewWrapper()
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
        .environmentObject(TabBarManager())
}
