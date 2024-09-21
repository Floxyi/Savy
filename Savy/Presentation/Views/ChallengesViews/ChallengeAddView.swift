//
//  ChallengeAddView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftUI
import SwiftData

struct ChallengeAddView: View {
    @Binding var showPopover: Bool
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    @State private var name: String = ""
    @State private var icon: String = ""
    @State private var date: Date = Date()
    
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
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .listRowBackground(currentSchema.accent1)
                    
                    TextField(text: $icon, prompt: Text("Challenge Icon")) {
                        Text("Icon Name")
                    }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .listRowBackground(currentSchema.accent1)
                    
                    DatePicker(
                        "End Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    .environment(\.colorScheme, .dark)
                    .accentColor(currentSchema.accent1)
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
                        icon: $icon,
                        date: $date,
                        showPopover: $showPopover
                    )
                }
                ToolbarItem(placement: .cancellationAction) {
                    ToolbarCancelButton(
                        name: $name,
                        date: $date,
                        showPopover: $showPopover
                    )
                }
            }
        }
    }
}

private struct ToolbarDoneButton: View {
    @Binding var name: String
    @Binding var icon: String
    @Binding var date: Date
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
            modelContext.insert(Challenge(name: name, icon: icon, startDate: Date(), endDate: date, targetAmount: 300))
            do {
                try modelContext.save()
            } catch {
                print(error.localizedDescription)
            }
            resetValues()
        }
    }
    
    private func resetValues() {
        name = ""
        date = Date()
    }
}

private struct ToolbarCancelButton: View {
    @Binding var name: String
    @Binding var date: Date
    @Binding var showPopover: Bool
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        Button("Cancel") {
            resetValues()
            showPopover = false
        }
        .font(.system(size: 16))
        .foregroundStyle(currentSchema.barIcons)
    }
    
    private func resetValues() {
        name = ""
        date = Date()
    }
}

#Preview {
    @Previewable @State var showPopover: Bool = true
    
    return Spacer()
        .popover(isPresented: $showPopover) {
            ChallengeAddView(showPopover: $showPopover)
        }
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
