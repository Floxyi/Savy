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
    @State private var password = ""
    
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
                        Text("Register")
                            .foregroundStyle(currentSchema.font)
                            .font(.system(size: 26))
                            .fontWeight(.bold)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 28)
                    .background(currentSchema.bar)
                    .cornerRadius(12)
                    .padding(.top, 72)
                    .onTapGesture {
                        signUpButtonTapped()
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
    
    func signUpButtonTapped() {
        Task {
            do {
                let appUser = try await AuthManager.shared.registerWithEmail(email: email, password: password)
                self.appUser = appUser
            }
        }
    }
}

#Preview {
    RegisterScreen(appUser: .constant(.init(uid: "1234", email: nil)))
        .modelContainer(for: [Challenge.self, ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
        .environmentObject(TabBarManager())
}
