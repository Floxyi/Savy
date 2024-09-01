//
//  LoginScreen.swift
//  Savy
//
//  Created by Nadine Schatz on 20.08.24.
//

import SwiftUI

struct LoginScreen: View {
    
    @State private var emailAddress = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Login")
                .font(.largeTitle.bold())
                .padding(.top, 80)
            Form {
                TextField("", text: $emailAddress, prompt: Text(verbatim: "someone@example.com"))
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
                    
            }
            .scrollContentBackground(.hidden)

            Spacer()
        }
    }
}

#Preview {
    LoginScreen()
}
