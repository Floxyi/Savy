//
//  InputFieldComponent.swift
//  Savy
//
//  Created by Florian Winkler on 23.09.24.
//

import SwiftData
import SwiftUI

struct AccountTextFieldView: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    @Binding var text: String
    @Binding var isValid: Bool
    @Binding var showPopup: Bool
    @Binding var error: Bool
    
    let placeholder: String
    let isSecure: Bool
    let validationFunction: () -> Void
    let popupText: String
    let keyboardType: UIKeyboardType
    let contentType: UITextContentType
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        ZStack(alignment: .trailing) {
            if isSecure {
                SecureField("", text: $text, prompt: Text(verbatim: placeholder)
                    .foregroundColor(currentSchema.font.opacity(0.4)))
            } else {
                TextField("", text: $text, prompt: Text(verbatim: placeholder)
                    .foregroundColor(currentSchema.font.opacity(0.4)))
            }
            
            HStack {
                if !isValid {
                    if error {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundStyle(currentSchema.font)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .padding(.trailing, 34)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in showPopup = true }
                                    .onEnded { _ in showPopup = false }
                            )
                    } else {
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(Color.red)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .padding(.trailing, 34)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in showPopup = true }
                                    .onEnded { _ in showPopup = false }
                            )
                    }
                }
                if isValid {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.green)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .padding(.trailing, 34)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in showPopup = true }
                                .onEnded { _ in showPopup = false }
                        )
                }
            }
        }
        .textFieldStyle(TextFieldAccountStyle())
        .textContentType(contentType)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .keyboardType(keyboardType)
        .onChange(of: text) {
            validationFunction()
        }
        .overlay(
            TextFieldPopoverView(showPopup: $showPopup, isValid: isValid, error: error, text: popupText)
        )
    }
}

#Preview("Email TextField") {
    struct PreviewWrapper: View {
        @State private var email = ""
        @State private var isEmailValid = false
        @State private var emailError = true
        @State private var showEmailPopup = false

        var body: some View {
            AccountTextFieldView(
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
        }
        
        func validateEmail() {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
            isEmailValid = emailPredicate.evaluate(with: email)
            emailError = email.isEmpty
        }
    }

    return PreviewWrapper()
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}

#Preview("Password TextField") {
    struct PreviewWrapper: View {
        @State private var password = ""
        @State private var isPasswordValid = false
        @State private var passwordError = true
        @State private var showPasswordPopup = false

        var body: some View {
            AccountTextFieldView(
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
        }
        
        func validatePassword() {
            isPasswordValid = password.count >= 8
            passwordError = password.isEmpty
        }
    }

    return PreviewWrapper()
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
