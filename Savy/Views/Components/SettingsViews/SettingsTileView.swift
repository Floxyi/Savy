//
//  SettingsTileView.swift
//  Savy
//
//  Created by Florian Winkler on 01.09.24.
//

import SwiftData
import SwiftUI

struct SettingsTileView<Content: View>: View {
    let image: String
    let text: String
    let content: Content

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    init(image: String, text: String, @ViewBuilder content: () -> Content) {
        self.image = image
        self.text = text
        self.content = content()
    }

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        VStack {
            HStack {
                Image(systemName: image)
                    .foregroundStyle(currentScheme.font)
                    .fontWeight(.bold)
                    .font(.system(size: 16))
                Text(text)
                    .foregroundStyle(currentScheme.font)
                    .fontWeight(.bold)
                    .font(.system(size: 16))
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            VStack {
                content
                    .padding(.bottom, 4)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .background(currentScheme.bar)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.bottom, 24)
    }
}

#Preview {
    @Previewable @State var toggle = true
    return SettingsTileView(image: "person.fill", text: "Account") {
        SettingsBarView(text: "Toggle", toggle: $toggle)
    }
    .padding()
    .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
