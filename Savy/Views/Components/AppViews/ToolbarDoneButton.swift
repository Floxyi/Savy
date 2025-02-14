//
//  ToolbarDoneButton.swift
//  Savy
//
//  Created by Florian Winkler on 26.09.24.
//

import SwiftData
import SwiftUI

struct ToolbarDoneButton: View {
    @Binding var showPopover: Bool

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    let title: String
    let isValid: () -> Bool
    let onDoneAction: () -> Void

    public var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        Button(action: {
            if isValid() {
                onDoneAction()
                showPopover = false
            }
        }) {
            Text(title)
                .foregroundColor(!isValid() ? currentScheme.barIcons.opacity(0.4) : currentScheme.barIcons)
                .font(.system(size: 16, weight: !isValid() ? .regular : .bold))
        }
        .disabled(!isValid())
    }
}

#Preview {
    @Previewable @State var showPopover = true

    let schema = Schema([ChallengeService.self, ColorService.self, StatsService.self])
    let container = try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext

    let colorServiceViewModel = ColorServiceViewModel(modelContext: context)

    return VStack {
        ToolbarDoneButton(
            showPopover: $showPopover,
            title: "Done",
            isValid: { true },
            onDoneAction: {
                print("Done tapped!")
            }
        )

        ToolbarDoneButton(
            showPopover: $showPopover,
            title: "Done",
            isValid: { false },
            onDoneAction: {
                print("Should not trigger")
            }
        )
    }
    .padding()
    .modelContainer(container)
    .environmentObject(colorServiceViewModel)
}
