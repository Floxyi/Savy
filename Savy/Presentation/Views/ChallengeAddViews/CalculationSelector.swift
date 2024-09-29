//
//  CalculationSelector.swift
//  Savy
//
//  Created by Florian Winkler on 26.09.24.
//

import SwiftUI

struct CalculationSelector: View {
    @Binding var selectedCalculation: SavingCalculation
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    public var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        HStack(spacing: 0) {
            Button(action: {
                selectedCalculation = .Date
            }) {
                Text(SavingCalculation.Date.rawValue)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(selectedCalculation == .Date ? currentSchema.font : currentSchema.font.opacity(0.4))
                    .frame(width: 146)
                    .padding(6)
                    .background(selectedCalculation == .Date ? currentSchema.accent1 : .clear)
                    .clipShape(Capsule())
                    .frame(maxWidth: .infinity)
            }
            
            Button(action: {
                selectedCalculation = .Amount
            }) {
                Text(SavingCalculation.Amount.rawValue)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(selectedCalculation == .Amount ? currentSchema.font : currentSchema.font.opacity(0.4))
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
    }
}
