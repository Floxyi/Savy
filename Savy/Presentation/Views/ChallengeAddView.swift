//
//  ChallengeAddView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftUI
import SwiftData

struct ChallengeAddView: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    @Binding var name: String
    @Binding var date: Date
    @Binding var notifications: Bool
    @Binding var showPopover: Bool

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        NavigationStack {
            VStack {
                Text("New Challenge")
                    .font(.system(size: 28).bold())
                    .foregroundStyle(colorManagerVM.colorManager.currentSchema.font)

                Form {
                    TextField(text: $name, prompt: Text("Challenge Name")) {
                        Text("Challenge Name")
                    }
                    .listRowBackground(currentSchema.accent1)

                    DatePicker(
                        "End Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    .environment(\.colorScheme, .dark)
                    .accentColor(currentSchema.accent1)
                    .listRowBackground(currentSchema.accent1)

                    Toggle("Send notifications", isOn: $notifications)
                        .toggleStyle(CustomToggleStyle())
                        .listRowBackground(currentSchema.accent1)
                }
                .scrollContentBackground(.hidden)
                .foregroundColor(currentSchema.font)

                Spacer()
            }
            .padding()
            .background(currentSchema.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    ToolbarDoneButton(
                        name: $name,
                        date: $date,
                        notifications: $notifications,
                        showPopover: $showPopover
                    )
                }
                ToolbarItem(placement: .cancellationAction) {
                    ToolbarCancelButton(
                        name: $name,
                        date: $date,
                        notifications: $notifications,
                        showPopover: $showPopover
                    )
                }
            }
        }
    }
}

private struct ToolbarDoneButton: View {
    @Binding var name: String
    @Binding var date: Date
    @Binding var notifications: Bool
    @Binding var showPopover: Bool

    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        Button(action: {
            addItem()
            showPopover = false
        }) {
            Text("Done")
                .foregroundColor(name.isEmpty ? currentSchema.barIcons.opacity(0.4) : currentSchema.barIcons)
        }
        .disabled(name.isEmpty)
    }

    private func addItem() {
        withAnimation {
            modelContext.insert(Challenge(name: name, date: date, notifications: notifications))
            do {
                try modelContext.save()
            } catch {
                print(error.localizedDescription)
            }
            cancelCreation()
        }
    }

    private func cancelCreation() {
        name = ""
        date = Date()
        notifications = false
    }
}

private struct ToolbarCancelButton: View {
    @Binding var name: String
    @Binding var date: Date
    @Binding var notifications: Bool
    @Binding var showPopover: Bool

    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        Button("Cancel") {
            cancelCreation()
            showPopover = false
        }
        .font(.system(size: 16))
        .foregroundStyle(currentSchema.barIcons)
    }

    private func cancelCreation() {
        name = ""
        date = Date()
        notifications = false
    }
}

