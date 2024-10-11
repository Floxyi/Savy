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
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            HeaderView(title: "Login", dismiss: {
                dismiss()
                TabBarManager().show()
            })
            .padding(.bottom, 88)
            
            if AuthManager.shared.isSignedIn() {
                Text("You are now logged in.")
            }
            
            if !AuthManager.shared.isSignedIn() {
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
            TabBarManager().hide()
        })
    }
    
    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validatePassword() -> Bool {
        return password.count >= 8
    }
    
    func signInButtonPressed() {
        isLoading = true
        authError = false
        Task {
            defer { isLoading = false }
            do {
                if validateEmail() && validatePassword() {
                    isSignedIn = try await AuthManager.shared.signInWithEmail(email: email, password: password)
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
