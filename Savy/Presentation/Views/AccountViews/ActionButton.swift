//
//  ActionButton.swift
//  Savy
//
//  Created by Florian Winkler on 23.09.24.
//

import SwiftData
import SwiftUI

struct ActionButton<Content: View>: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    let content: Content
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        HStack {
            content
                .foregroundStyle(isEnabled ? currentScheme.font : currentScheme.accent1)
        }
        .frame(width: 140)
        .padding(.vertical, 16)
        .padding(.horizontal, 28)
        .background(currentScheme.bar)
        .cornerRadius(12)
        .onTapGesture {
            if isEnabled {
                action()
            }
        }
    }
}

#Preview("Text Button") {
    ActionButton(
        content: HStack {
            Text("Login")
                .font(.system(size: 26))
                .fontWeight(.bold)
            Image(systemName: "arrow.right")
                .fontWeight(.bold)
                .font(.system(size: 20))
        },
        isEnabled: true,
        action: {}
    )
    .modelContainer(for: [ColorService.self])
    .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}

#Preview("Loading Button") {
    ActionButton(
        content: HStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .frame(width: 20, height: 20)
        },
        isEnabled: true,
        action: {}
    )
    .modelContainer(for: [ColorService.self])
    .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
