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

    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    init(image: String, text: String, @ViewBuilder content: () -> Content) {
        self.image = image
        self.text = text
        self.content = content()
    }

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        VStack {
            HStack {
                Image(systemName: image)
                    .foregroundStyle(currentSchema.font)
                    .fontWeight(.bold)
                    .font(.system(size: 16))
                Text(text)
                    .foregroundStyle(currentSchema.font)
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
        .background(currentSchema.bar)
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
    .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
