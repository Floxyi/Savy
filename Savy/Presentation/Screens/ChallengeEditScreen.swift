//
//  ChallengeEditView.swift
//  Savy
//
//  Created by Florian Winkler on 11.10.24.
//

import SwiftUI
import SwiftData

struct ChallengeEditScreen: View {
    var challenge: Challenge
    
    @Binding var showPopover: Bool
    
    @State private var icon: String?
    @State private var name: String = ""
    @State private var amount: Int?
    @State private var strategy: SavingStrategy = .Weekly
    @State private var calculation: SavingCalculation = .Date
    @State private var cycleAmount: Int?
    @State private var endDate: Date = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date()
    
    @State private var isDatePickerVisible = false
    @State private var isIconPickerVisible = false
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        let challengeConfiguration = ChallengeConfiguration(
            icon: icon ?? "square.dashed",
            name: name,
            amount: amount ?? 0,
            endDate: endDate,
            strategy: strategy,
            calculation: calculation,
            cycleAmount: cycleAmount
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
                        
                        StrategySelector(selectedStrategy: $strategy, onChangeAction: { updateEndDate() })
                    }
                    .frame(height: 38)
                    .background(currentSchema.bar)
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    
                    CalculationSelector(selectedCalculation: $calculation)
                    
                    if calculation == .Date {
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
                        
                        Text("\(strategy) Amount: \(challengeConfiguration.calculateCycleAmount() ?? 0) €")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(currentSchema.font)
                            .padding()
                    }
                    
                    if calculation == .Amount {
                        VStack {
                            HStack {
                                TextField("", value: $cycleAmount, format: .number, prompt: Text(verbatim: "\(strategy) Amount")
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
                            isValid: { isValid() },
                            onDoneAction: { }
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
                                byAdding: strategy == .Weekly ? .weekOfYear : .month,
                                value: 1,
                                to: Date()
                            ) ?? Date()
                        )
                        
                        HStack {
                            Text("\(strategy) Amount: \(challengeConfiguration.calculateCycleAmount() ?? 0) €")
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
            .onAppear {
                loadChallengeData()
            }
        }
    }
    
    private func loadChallengeData() {
        icon = challenge.challengeConfiguration.icon
        name = challenge.challengeConfiguration.name
        amount = challenge.challengeConfiguration.amount
        endDate = challenge.challengeConfiguration.endDate
        strategy = challenge.challengeConfiguration.strategy
        calculation = challenge.challengeConfiguration.calculation
        cycleAmount = challenge.challengeConfiguration.cycleAmount
    }
    
    private func updateEndDate() {
        let newEndDate = Calendar.current.date(
            byAdding: strategy == .Weekly ? .weekOfYear : .month,
            value: 1,
            to: Date()
        ) ?? Date()
        
        endDate = newEndDate > endDate ? newEndDate : endDate
    }
    
    private func isValid() -> Bool {
        return icon != nil && name != "" && amount != nil && (calculation == .Amount ? cycleAmount != nil : true)
    }
}

#Preview {
    @Previewable @State var showPopover: Bool = true
    
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let challengeConfiguration = ChallengeConfiguration(
        icon: "homepod",
        name: "HomePod",
        amount: 300,
        startDate: Date(),
        strategy: .Monthly,
        calculation: .Amount,
        cycleAmount: 12
    )
    ChallengeManager.shared.addChallenge(challengeConfiguration: challengeConfiguration)
    
    return Spacer()
        .popover(isPresented: $showPopover) {
            ChallengeEditScreen(challenge: Challenge(challengeConfiguration: challengeConfiguration), showPopover: $showPopover)
        }
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
}
