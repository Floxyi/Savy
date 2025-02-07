//
//  LoginTextFieldView.swift
//  Savy
//
//  Created by Florian Winkler on 29.09.24.
//

import SwiftData
import SwiftUI

struct LoginTextFieldView: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    @Binding var text: String

    let placeholder: String
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let contentType: UITextContentType

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        VStack(alignment: .trailing) {
            if isSecure {
                SecureField("", text: $text, prompt: Text(verbatim: placeholder)
                    .foregroundColor(currentScheme.font.opacity(0.4)))
            } else {
                TextField("", text: $text, prompt: Text(verbatim: placeholder)
                    .foregroundColor(currentScheme.font.opacity(0.4)))
            }
        }
        .textFieldStyle(TextFieldAccountStyle())
        .textContentType(contentType)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .keyboardType(keyboardType)
    }
}

#Preview("Email TextField") {
    struct PreviewWrapper: View {
        @State private var email = ""

        var body: some View {
            LoginTextFieldView(
                text: $email,
                placeholder: "someone@example.com",
                isSecure: false,
                keyboardType: .emailAddress,
                contentType: .emailAddress
            )
        }
    }

    return PreviewWrapper()
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}

#Preview("Password TextField") {
    struct PreviewWrapper: View {
        @State private var password = ""

        var body: some View {
            LoginTextFieldView(
                text: $password,
                placeholder: "password",
                isSecure: true,
                keyboardType: .default,
                contentType: .password
            )
        }
    }

    return PreviewWrapper()
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
