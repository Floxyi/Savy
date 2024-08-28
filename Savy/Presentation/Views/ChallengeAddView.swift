//
//  ChallengeAddView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftUI
import SwiftData

struct CustomToggleStyle: ToggleStyle {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.isOn ? colorManagerVM.colorManager.currentSchema.accent2 : colorManagerVM.colorManager.currentSchema.background)
                    .frame(width: 51, height: 31)

                Circle()
                    .fill(colorManagerVM.colorManager.currentSchema.bar)
                    .frame(width: 27, height: 27)
                    .offset(x: configuration.isOn ? 10 : -10)
                    .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
}

struct ChallengeAddView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    @Binding var name: String
    @Binding var date: Date
    @Binding var notifications: Bool
    @Binding var showPopover: Bool

    fileprivate func ToolbarDoneButton() -> ToolbarItem<(), some View> {
        return ToolbarItem(placement: .confirmationAction) {
            Button(action: {
                addItem()
                showPopover = false
            }) {
                Text("Done")
                    .foregroundColor(name.isEmpty ? colorManagerVM.colorManager.currentSchema.barIcons.opacity(0.4) : colorManagerVM.colorManager.currentSchema.barIcons)
            }
            .disabled(name.isEmpty)
        }
    }
    
    fileprivate func ToolbarCancelButton() -> ToolbarItem<(), some View> {
        return ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                cancelCreation()
                showPopover = false
            }
            .font(.system(size: 16))
            .foregroundStyle(colorManagerVM.colorManager.currentSchema.barIcons)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("New Challenge")
                    .font(.system(size: 28).bold())
                    .foregroundStyle(colorManagerVM.colorManager.currentSchema.font)

                Form {
                    TextField(text: $name, prompt: Text("Challenge Name")) {
                        Text("Challenge Name")
                    }
                    .listRowBackground(colorManagerVM.colorManager.currentSchema.accent1)

                    DatePicker(
                        "End Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    .environment(\.colorScheme, .dark)
                    .accentColor(colorManagerVM.colorManager.currentSchema.accent1)
                    .listRowBackground(colorManagerVM.colorManager.currentSchema.accent1)

                    Toggle("Send notifications", isOn: $notifications)
                        .toggleStyle(CustomToggleStyle())
                        .listRowBackground(colorManagerVM.colorManager.currentSchema.accent1)
                }
                .scrollContentBackground(.hidden)
                .foregroundColor(colorManagerVM.colorManager.currentSchema.font)

                Spacer()
            }
            .padding()
            .background(colorManagerVM.colorManager.currentSchema.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarDoneButton()
                ToolbarCancelButton()
            }
        }
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
