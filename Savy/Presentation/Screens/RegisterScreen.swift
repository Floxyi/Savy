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
    
    @State private var emailUnavailable = false
    
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
                    ZStack(alignment: .trailing) {
                        TextField("", text: $email, prompt: Text(verbatim: "someone@example.com")
                            .foregroundColor(currentSchema.font.opacity(0.4)))
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .textFieldStyle(TextFieldAccountStyle())
                        .onChange(of: email) {
                            validateEmail()
                            emailUnavailable = false
                        }
                        
                        HStack {
                            if !isEmailValid {
                                if emailError {
                                    Image(systemName: "questionmark.circle.fill")
                                        .foregroundStyle(currentSchema.font)
                                        .fontWeight(.bold)
                                        .font(.system(size: 20))
                                        .padding(.trailing, 34)
                                        .gesture(
                                            DragGesture(minimumDistance: 0)
                                                .onChanged { _ in showEmailPopup = true }
                                                .onEnded { _ in showEmailPopup = false }
                                        )
                                } else {
                                    Image(systemName: "x.circle.fill")
                                        .foregroundStyle(Color.red)
                                        .fontWeight(.bold)
                                        .font(.system(size: 20))
                                        .padding(.trailing, 34)
                                        .gesture(
                                            DragGesture(minimumDistance: 0)
                                                .onChanged { _ in showEmailPopup = true }
                                                .onEnded { _ in showEmailPopup = false }
                                        )
                                }
                            }
                            if isEmailValid {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color.green)
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .padding(.trailing, 34)
                                    .gesture(
                                        DragGesture(minimumDistance: 0)
                                            .onChanged { _ in showEmailPopup = true }
                                            .onEnded { _ in showEmailPopup = false }
                                    )
                            }
                        }
                    }
                    .overlay(
                        Group {
                            if showEmailPopup {
                                VStack {
                                    Text(isEmailValid ? "Valid email address." : emailError ? "Please provide a valid email address." : "This is not a valid email address.")
                                        .foregroundColor(isEmailValid ? .green : emailError ? .gray : .red)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding()
                                        .padding(.trailing, 14)
                                        .cornerRadius(8)
                                        .shadow(radius: 4)
                                        .background(
                                            SpeechBubbleShape()
                                                .fill(Color.white)
                                                .shadow(radius: 4)
                                        )
                                }
                                .transition(.scale)
                                .animation(.spring(), value: showEmailPopup)
                            }
                        }
                    )
                    
                    ZStack(alignment: .trailing) {
                        SecureField("", text: $password, prompt: Text(verbatim: "password")
                            .foregroundColor(currentSchema.font.opacity(0.4)))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(TextFieldAccountStyle())
                        .padding(.bottom, 0)
                        .onChange(of: password) {
                            validatePassword()
                        }
                        
                        HStack {
                            if !isPasswordValid {
                                if passwordError {
                                    Image(systemName: "questionmark.circle.fill")
                                        .foregroundStyle(currentSchema.font)
                                        .fontWeight(.bold)
                                        .font(.system(size: 20))
                                        .padding(.trailing, 34)
                                        .gesture(
                                            DragGesture(minimumDistance: 0)
                                                .onChanged { _ in showPasswordPopup = true }
                                                .onEnded { _ in showPasswordPopup = false }
                                        )
                                } else {
                                    Image(systemName: "x.circle.fill")
                                        .foregroundStyle(Color.red)
                                        .fontWeight(.bold)
                                        .font(.system(size: 20))
                                        .padding(.trailing, 34)
                                        .gesture(
                                            DragGesture(minimumDistance: 0)
                                                .onChanged { _ in showPasswordPopup = true }
                                                .onEnded { _ in showPasswordPopup = false }
                                        )
                                }
                            }
                            if isPasswordValid {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color.green)
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .padding(.trailing, 34)
                                    .gesture(
                                        DragGesture(minimumDistance: 0)
                                            .onChanged { _ in showPasswordPopup = true }
                                            .onEnded { _ in showPasswordPopup = false }
                                    )
                            }
                        }
                    }
                    .overlay(
                        Group {
                            if showPasswordPopup {
                                VStack {
                                    Text(isPasswordValid ? "Valid password." : passwordError ? "Please provide a 8 chatacter password." : "This password is not 8 characters long.")
                                        .foregroundColor(isPasswordValid ? .green : passwordError ? .gray : .red)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding()
                                        .padding(.trailing, 14)
                                        .cornerRadius(8)
                                        .shadow(radius: 4)
                                        .background(
                                            SpeechBubbleShape()
                                                .fill(Color.white)
                                                .shadow(radius: 4)
                                        )
                                }
                                .transition(.scale)
                                .animation(.spring(), value: showPasswordPopup)
                            }
                        }
                    )
                    
                    Text("This email adress is already registered.")
                        .foregroundStyle(emailUnavailable ? Color.red : currentSchema.background)
                    
                    HStack {
                        Text("Register")
                            .foregroundStyle(isEmailValid && isPasswordValid ? currentSchema.font : currentSchema.accent1)
                            .font(.system(size: 26))
                            .fontWeight(.bold)
                        Image(systemName: "arrow.right")
                            .foregroundStyle(isEmailValid && isPasswordValid ? currentSchema.font : currentSchema.accent1)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 28)
                    .background(currentSchema.bar)
                    .cornerRadius(12)
                    .padding(.top, 72)
                    .onTapGesture {
                        if isEmailValid && isPasswordValid {
                            signUpButtonTapped()
                        }
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
    
    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: email)
        emailError = isEmailValid
    }
    
    func validatePassword() {
        isPasswordValid = password.count >= 6
        passwordError = isPasswordValid
    }
    
    func signUpButtonTapped() {
        Task {
            do {
                let appUser = try await AuthManager.shared.registerWithEmail(email: email, password: password)
                self.appUser = appUser
            } catch {
                emailUnavailable = true
            }
        }
    }
}

struct SpeechBubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let cornerRadius: CGFloat = 8
        let triangleHeight: CGFloat = 20
        let triangleWidth: CGFloat = 15
        
        path.addRoundedRect(in: CGRect(x: 0, y: 0, width: rect.width - triangleWidth, height: rect.height), cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        path.move(to: CGPoint(x: rect.width - triangleWidth, y: rect.height / 2 - triangleHeight / 2))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width - triangleWidth, y: rect.height / 2 + triangleHeight / 2))
        
        return path
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
