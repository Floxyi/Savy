//
//  SettingsBarView.swift
//  Savy
//
//  Created by Florian Winkler on 01.09.24.
//

import SwiftData
import SwiftUI

struct SettingsBarView<Content: View>: View {
    var text: String
    @Binding var toggle: Bool
    let content: () -> Content

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    init(text: String, toggle: Binding<Bool>, @ViewBuilder content: @escaping () -> Content = {
        EmptyView()
    }) {
        self.text = text
        _toggle = toggle
        self.content = content
    }

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        VStack {
            HStack {
                Toggle(isOn: $toggle, label: {
                    Text(text)
                        .foregroundStyle(currentScheme.font)
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .padding(.horizontal, 4)
                })
                .toggleStyle(CustomToggleStyle())
                .padding(4)
            }
            content()
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
        }
        .background(currentScheme.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    @Previewable @State var toggle = true
    return VStack {
        SettingsBarView(text: "Toggle", toggle: $toggle)
        SettingsBarView(text: "Toggle", toggle: $toggle) {
            Text("Account settings.")
        }
    }
    .padding()
    .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
