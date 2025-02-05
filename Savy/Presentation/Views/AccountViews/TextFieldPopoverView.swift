//
//  TextFieldPopoverView.swift
//  Savy
//
//  Created by Florian Winkler on 23.09.24.
//

import SwiftData
import SwiftUI

struct TextFieldPopoverView: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    @Binding var showPopup: Bool

    let isValid: Bool
    let error: Bool
    let text: String

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        Group {
            if showPopup {
                VStack {
                    Text(text)
                        .foregroundColor(isValid ? .green : error ? currentSchema.font : .red)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding()
                        .padding(.trailing, 14)
                        .cornerRadius(8)
                        .background(
                            SpeechBubbleShape()
                                .fill(currentSchema.background)
                                .shadow(radius: 4)
                        )
                }
                .transition(.scale)
                .animation(.spring(), value: showPopup)
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
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
