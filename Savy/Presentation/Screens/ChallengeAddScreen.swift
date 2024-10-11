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
    
    @State private var icon: String?
    @State private var name: String = ""
    @State private var amount: Int?
    @State private var selectedStrategy: SavingStrategy = .Weekly
    @State private var selectedCalculation: SavingCalculation = .Date
    @State private var cycleAmount: Int?
    @State private var endDate: Date = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date()
    
    @State private var isDatePickerVisible = false
    @State private var isIconPickerVisible = false
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        let challengeConfiguration = ChallengeConfiguration(
            name: name,
            amount: amount,
            icon: icon,
            strategy: selectedStrategy,
            calculation: selectedCalculation,
            cycleAmount: cycleAmount,
            endDate: endDate
        )
        
        NavigationStack {
            ZStack {
                VStack {
                    IconPicker(selectedIcon: $icon, isIconPickerVisible: $isIconPickerVisible)
                    
                    TextField("", text: $name, prompt: Text(verbatim: "Name")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(currentSchema.font.opacity(0.4)))
                        .textInputAutocapitalization(.never)
                    .textFieldStyle(CustomTextFieldStyle())
                    .onChange(of: name) { _, newValue in
                        if newValue.count > 12 {
                            name = String(newValue.prefix(12))
                        }
                    }
                    
                    HStack {
                        TextField("", value: $amount, format: .number, prompt: Text(verbatim: "Amount")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(currentSchema.font.opacity(0.4)))
                        .textFieldStyle(CustomTextFieldStyle())
                        .keyboardType(.numberPad)
                        Text("€")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(currentSchema.font)
                            .padding(.trailing, 32)
                    }
                    
                    HStack {
                        Text("Strategy")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(currentSchema.font.opacity(0.4))
                            .padding(.leading, 8)
                        
                        Spacer()
                        
                        StrategySelector(selectedStrategy: $selectedStrategy, onChangeAction: { updateEndDate() })
                    }
                    .frame(height: 38)
                    .background(currentSchema.bar)
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    
                    CalculationSelector(selectedCalculation: $selectedCalculation)
                    
                    if selectedCalculation == .Date {
                        HStack {
                            DatePicker(
                                "",
                                selection: $endDate,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(CustomDatePickerStyle(date: endDate, text: "End date:", isDatePickerVisible: $isDatePickerVisible))
                        }
                        .padding(.horizontal, 8)
                        .frame(height: 38)
                        .background(currentSchema.bar)
                        .cornerRadius(8)
                        .padding(.top, 8)
                        .padding(.horizontal, 24)
                        
                        Text("\(selectedStrategy) Amount: \(challengeConfiguration.calculateCycleAmount() ?? 0) €")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(currentSchema.font)
                            .padding()
                    }
                    
                    if selectedCalculation == .Amount {
                        VStack {
                            HStack {
                                TextField("", value: $cycleAmount, format: .number, prompt: Text(verbatim: "\(selectedStrategy) Amount")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(currentSchema.font.opacity(0.4)))
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.numberPad)
                                Text("€")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(currentSchema.font)
                                    .padding(.trailing, 32)
                            }
                        }
                        .frame(height: 38)
                        .padding(.top, 8)
                        .padding(.horizontal, 8)
                        
                        Text("End Date: \(challengeConfiguration.calculateEndDateByAmount().formatted(.dateTime.day().month().year()))")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(currentSchema.font)
                            .padding()
                    }
                    
                    Spacer()
                    HStack {
                        Spacer()
                    }
                }
                .padding()
                .background(currentSchema.background)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        ToolbarDoneButton(
                            showPopover: $showPopover,
                            title: "Done",
                            isValid: { challengeConfiguration.isValid() },
                            onDoneAction: {
                                
                                ChallengeManager.shared.addChallenge(challenge: challengeConfiguration.createChallenge())
                                StatsTracker.shared.addChallengeStartedStatsEntry()
                            }
                        )
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        ToolbarCancelButton(showPopover: $showPopover)
                    }
                }
                
                if isDatePickerVisible || isIconPickerVisible {
                    DismissableOverlay(bindings: [$isDatePickerVisible, $isIconPickerVisible])
                }
                
                if isDatePickerVisible {
                    VStack {
                        CustomDatePickerOverlay(
                            date: $endDate,
                            startDate: Calendar.current.date(
                                byAdding: selectedStrategy == .Weekly ? .weekOfYear : .month,
                                value: 1,
                                to: Date()
                            ) ?? Date()
                        )
                        
                        HStack {
                            Text("\(selectedStrategy) Amount: \(challengeConfiguration.calculateCycleAmount() ?? 0) €")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(currentSchema.font)
                                .padding(8)
                        }
                        .background(currentSchema.background)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.top, 22)
                    }
                }
                
                if isIconPickerVisible {
                    IconPickerOverlay(selectedIcon: $icon, isIconPickerVisible: $isIconPickerVisible)
                }
            }
        }
    }
    
    private func updateEndDate() {
        let newEndDate = Calendar.current.date(
            byAdding: selectedStrategy == .Weekly ? .weekOfYear : .month,
            value: 1,
            to: Date()
        ) ?? Date()
        
        endDate = newEndDate > endDate ? newEndDate : endDate
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
