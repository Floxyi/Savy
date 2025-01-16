//
//  LoginTextFieldView.swift
//  Savy
//
//  Created by Florian Winkler on 29.09.24.
//

import SwiftData
import SwiftUI

struct LoginTextFieldView: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    @Binding var text: String

    let placeholder: String
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let contentType: UITextContentType

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        VStack(alignment: .trailing) {
            if isSecure {
                SecureField("", text: $text, prompt: Text(verbatim: placeholder)
                    .foregroundColor(currentSchema.font.opacity(0.4)))
            } else {
                TextField("", text: $text, prompt: Text(verbatim: placeholder)
                    .foregroundColor(currentSchema.font.opacity(0.4)))
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
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
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
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
