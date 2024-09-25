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
    
    @State private var name: String = ""
    @State private var amount: Int?
    @State private var selectedStrategy: Strategy = .Weekly
    @State private var selectedCalculation: Calculation = .Date
    @State private var cycleAmount: Int?
    @State private var endDate: Date = Date()
    
    @State private var isDatePickerVisible = false
    @State private var isValid: Bool = true
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        let challengeConfiguration = ChallengeConfiguration(
            name: name,
            amount: amount,
            strategy: selectedStrategy,
            calculation: selectedCalculation,
            cycleAmount: cycleAmount,
            endDate: endDate
        )
        
        NavigationStack {
            ZStack {
                VStack {
                    VStack {
                        Text("Choose icon")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(currentSchema.font)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 75, height: 75)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: [5]))
                            .foregroundColor(currentSchema.font)
                    )
                    .padding(.bottom, 16)
                    
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
                        
                        Menu {
                            ForEach(Strategy.allCases, id: \.self) { strategy in
                                Button(action: {
                                    selectedStrategy = strategy
                                }) {
                                    Text(strategy.rawValue)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedStrategy.rawValue)
                                    .font(.system(size: 16))
                                    .foregroundColor(currentSchema.font)
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 16))
                                    .foregroundColor(currentSchema.font)
                            }
                            .padding(.horizontal, 8)
                            .background(currentSchema.bar)
                        }
                    }
                    .frame(height: 38)
                    .background(currentSchema.bar)
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    
                    HStack(spacing: 0) {
                        Button(action: {
                            selectedCalculation = .Date
                        }) {
                            Text(Calculation.Date.rawValue)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(selectedCalculation == .Date ? currentSchema.font :  currentSchema.font.opacity(0.4))
                                .frame(width: 146)
                                .padding(6)
                                .background(selectedCalculation == .Date ? currentSchema.accent1 : .clear)
                                .clipShape(Capsule())
                                .frame(maxWidth: .infinity)
                        }
                        
                        Button(action: {
                            selectedCalculation = .Amount
                        }) {
                            Text(Calculation.Amount.rawValue)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(selectedCalculation == .Amount ? currentSchema.font :  currentSchema.font.opacity(0.4))
                                .frame(width: 146)
                                .padding(6)
                                .background(selectedCalculation == .Amount ? currentSchema.accent1 : .clear)
                                .clipShape(Capsule())
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 42)
                    .background(currentSchema.bar)
                    .cornerRadius(20)
                    .padding(.horizontal, 16)
                    .padding(.top, 38)
                    
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
                    }
                    
                    if selectedCalculation == .Date {
                        Text("\(challengeConfiguration.calculateCycleAmount() ?? 0) €")
                            .padding()
                    }
                    
                    if selectedCalculation == .Amount {
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
                        ToolbarDoneButton(isValid: $isValid, showPopover: $showPopover, challengeConfiguration: challengeConfiguration)
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        ToolbarCancelButton(showPopover: $showPopover)
                    }
                }
                
                if isDatePickerVisible {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                        }
                    }
                    .background(.black.opacity(0.4))
                    .onTapGesture {
                        withAnimation {
                            isDatePickerVisible = false
                        }
                    }
                }
                
                VStack {
                    DatePicker("", selection: $endDate, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .accentColor(currentSchema.font)
                        .labelsHidden()
                        .padding(.horizontal)
                        .background(currentSchema.background, in: RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 10)
                        .frame(width: 300)
                        .frame(maxWidth: .infinity)
                    
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
                .opacity(isDatePickerVisible ? 1 : 0)
            }
        }
    }
}

private struct ToolbarDoneButton: View {
    @Binding var isValid: Bool
    @Binding var showPopover: Bool
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var challengeConfiguration: ChallengeConfiguration
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        Button(action: {
            showPopover = false
            modelContext.insert(challengeConfiguration.createChallenge())
        }) {
            Text("Done")
                .foregroundColor(!isValid ? currentSchema.barIcons.opacity(0.4) : currentSchema.barIcons)
        }
        .disabled(!isValid)
    }
}

private struct ToolbarCancelButton: View {
    @Binding var showPopover: Bool
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        Button("Cancel") {
            showPopover = false
        }
        .font(.system(size: 16))
        .foregroundStyle(currentSchema.barIcons)
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
