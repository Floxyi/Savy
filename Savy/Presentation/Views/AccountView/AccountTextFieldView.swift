//
//  InputFieldComponent.swift
//  Savy
//
//  Created by Florian Winkler on 23.09.24.
//


import SwiftUI

struct AccountTextFieldView: View {
    @Binding var text: String
    @Binding var isValid: Bool
    @Binding var showPopup: Bool
    @Binding var error: Bool
    
    let placeholder: String
    let isSecure: Bool
    let validationFunction: () -> Void
    let popupText: String
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
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
        .textContentType(isSecure ? .password : .emailAddress)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .keyboardType(isSecure ? .default : .emailAddress)
        .onChange(of: text) {
            validationFunction()
        }
        .overlay(
            TextFieldPopoverView(showPopup: $showPopup, isValid: isValid, error: error, text: popupText)
        )
    }
}
