//
//  LoginScreen.swift
//  Savy
//
//  Created by Nadine Schatz on 20.08.24.
//

import SwiftData
import SwiftUI

struct LoginScreen: View {
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    @State private var emailAddress = ""
    @State private var password = ""
    
    var body: some View {
        
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            HeaderView(title: "Login")
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
            
            HStack {
                Text("Log in")
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
            
            HStack {
                Text("No account yet? Register")
                    .foregroundColor(currentSchema.font.opacity(0.6))
                    .padding(.trailing, -2)
                
                Text("here.")
                    .foregroundColor(currentSchema.font.opacity(0.6))
                    .underline()
                    .padding(.leading, -2)
            }
            
            Spacer()
            HStack {
                Spacer()
            }
        }
        .padding(.top, 92)
        .padding(.bottom, 112)
        .background(currentSchema.background)
    }
}

#Preview {
    LoginScreen()
        .modelContainer(for: [Challenge.self, ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
