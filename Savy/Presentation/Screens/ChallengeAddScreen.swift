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
    @State private var selectedStrategy: Strategy = .Weekly
    @State private var selectedCalculation: Calculation = .Date
    @State private var cycleAmount: Int?
    @State private var endDate: Date = Date()
    
    @State private var isDatePickerVisible = false
    
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
                    IconPicker(selectedIcon: $icon)
                    
                    TextField("", text: $name, prompt: Text(verbatim: "Name")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(currentSchema.font.opacity(0.4)))
                    .textFieldStyle(CustomTextFieldStyle())
                    
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
                        
                        StrategySelector(selectedStrategy: $selectedStrategy)
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
                        
                        Text("\(challengeConfiguration.calculateCycleAmount() ?? 0) €")
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
                        
                        Text("\(challengeConfiguration.calculateEndDateByAmount().formatted(.dateTime.day().month().year()))")
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
                            challengeConfiguration: challengeConfiguration
                        )
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        ToolbarCancelButton(showPopover: $showPopover)
                    }
                }
                
                if isDatePickerVisible {
                    DismissableOverlay(bindings: [$isDatePickerVisible])
                }
                
                if isDatePickerVisible {
                    VStack {
                        CustomDatePicker(date: $endDate)
                        
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
            }
        }
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
