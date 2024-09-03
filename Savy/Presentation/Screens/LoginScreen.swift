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
    
    @State private var emailAddress = ""
    @State private var password = ""
    
    @State var isLoading = false
    @State var result: Result<Void, Error>?
    
    @State var isAuthenticated = false
    
    var body: some View {
        
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            HeaderView(title: "Login", dismiss: {
                dismiss()
                tabBarManager.show()
            })
                .padding(.bottom, 88)
            
            TextField("", text: $emailAddress, prompt: Text(verbatim: "someone@example.com")
                .foregroundColor(currentSchema.font.opacity(0.4)))
                .keyboardType(.emailAddress)
                .textFieldStyle(TextFieldAccountStyle())
            
            SecureField("", text: $password, prompt: Text(verbatim: "password")
                .foregroundColor(currentSchema.font.opacity(0.4)))
            .textFieldStyle(TextFieldAccountStyle())
            .padding(.bottom, 0)
            
            HStack {
                Text("Forgot password?")
                    .foregroundColor(currentSchema.font.opacity(0.6))
                    .padding(.top, -10)
                    .padding(.leading, 32)
                    .underline()
                Spacer()
            }
            
            if !isAuthenticated {
                HStack {
                    Text("Log in")
                        .foregroundStyle(currentSchema.font)
                        .font(.system(size: 26))
                        .fontWeight(.bold)
                    if !isLoading {
                        Image(systemName: "arrow.forward")
                            .foregroundStyle(currentSchema.font)
                            .font(.system(size: 20))
                    } else {
                        ProgressView()
                            .padding()
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 28)
                .background(currentSchema.bar)
                .cornerRadius(12)
                .padding(.top, 72)
                .onTapGesture {
                    signInButtonTapped()
                }
            } else {
                HStack {
                    Text("Continue")
                        .foregroundStyle(currentSchema.font)
                        .font(.system(size: 26))
                        .fontWeight(.bold)
                    Image(systemName: "arrow.forward")
                        .foregroundStyle(currentSchema.font)
                        .font(.system(size: 20))
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 28)
                .background(currentSchema.bar)
                .cornerRadius(12)
                .padding(.top, 72)
            }
            
            HStack {
                Text("No account yet? Register")
                    .foregroundColor(currentSchema.font.opacity(0.6))
                    .padding(.trailing, -2)
                
                Text("here.")
                    .foregroundColor(currentSchema.font.opacity(0.6))
                    .underline()
                    .padding(.leading, -2)
            }
            
            if isAuthenticated {
                Text("Sueccess!")
            }
            
            if let result {
                switch result {
                case .success:
                    Text("Check your inbox.")
                case .failure(let error):
                    Text(error.localizedDescription).foregroundStyle(.red)
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
        .onOpenURL(perform: { url in
            Task {
                do {
                    try await supabase.auth.session(from: url)
                    for await state in supabase.auth.authStateChanges {
                        if [.signedIn].contains(state.event) {
                            isAuthenticated = state.session != nil
                        }
                    }
                    self.result = .success(())
                } catch {
                    self.result = .failure(error)
                }
            }
        })
        .onAppear(perform: {
            tabBarManager.hide()
        })
    }
    
    func signInButtonTapped() {
        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                try await supabase.auth.signUp(
                    email: emailAddress,
                    password: password,
                    redirectTo: URL(string: "de.savy://login-callback")
                )
                result = .success(())
            } catch {
                result = .failure(error)
            }
        }
    }
}

#Preview {
    LoginScreen()
        .modelContainer(for: [Challenge.self, ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
        .environmentObject(TabBarManager())
}
