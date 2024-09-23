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
    @EnvironmentObject private var tabBarManager: TabBarManager
    
    @State private var email = ""
    @State private var password = ""
    
    @Binding var appUser: AppUser?
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            HeaderView(title: "Login", dismiss: {
                dismiss()
                tabBarManager.show()
            })
            .padding(.bottom, 88)
            
            if appUser != nil {
                Text("You are now logged in.")
            } else {
                VStack {
                    TextField("", text: $email, prompt: Text(verbatim: "someone@example.com")
                        .foregroundColor(currentSchema.font.opacity(0.4)))
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textFieldStyle(TextFieldAccountStyle())
                    
                    SecureField("", text: $password, prompt: Text(verbatim: "password")
                        .foregroundColor(currentSchema.font.opacity(0.4)))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(TextFieldAccountStyle())
                    .padding(.bottom, 0)
                    
                    HStack {
                        Text("Log In")
                            .foregroundStyle(currentSchema.font)
                            .font(.system(size: 26))
                            .fontWeight(.bold)
                        Image(systemName: "arrow.right")
                            .foregroundStyle(currentSchema.font)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 28)
                    .background(currentSchema.bar)
                    .cornerRadius(12)
                    .padding(.top, 72)
                    .onTapGesture {
                        signInButtonTapped()
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
            tabBarManager.hide()
        })
    }
    
    func signInButtonTapped() {
        Task {
            do {
                let appUser = try await AuthManager.shared.signInWithEmail(email: email, password: password)
                self.appUser = appUser
            }
        }
    }
}

#Preview("Logged Out") {
    struct PreviewWrapper: View {
        @State private var dummyUser: AppUser? = nil
        
        var body: some View {
            LoginScreen(appUser: $dummyUser)
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
            LoginScreen(appUser: $dummyUser)
        }
    }
    
    return PreviewWrapper()
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
        .environmentObject(TabBarManager())
}
