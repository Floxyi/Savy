//
//  TextFieldPopoverView.swift
//  Savy
//
//  Created by Florian Winkler on 23.09.24.
//

import SwiftData
import SwiftUI

struct TextFieldPopoverView: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    @Binding var showPopup: Bool

    let isValid: Bool
    let error: Bool
    let text: String

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        Group {
            if showPopup {
                VStack {
                    Text(text)
                        .foregroundColor(isValid ? .green : error ? currentScheme.font : .red)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(currentScheme.background)
                        .cornerRadius(10)
                        .shadow(radius: 12)
                }
                .transition(.scale)
                .animation(.spring(), value: showPopup)
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var email = ""
        @State private var isEmailValid = false
        @State private var emailError = true
        @State private var showEmailPopup = false

        var body: some View {
            RegistrationTextFieldView(
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
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            isEmailValid = emailPredicate.evaluate(with: email)
            emailError = email.isEmpty
        }
    }

    return PreviewWrapper()
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
