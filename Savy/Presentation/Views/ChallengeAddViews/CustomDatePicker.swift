//
//  CustomDatePicker.swift
//  Savy
//
//  Created by Florian Winkler on 26.09.24.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var date: Date
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    public var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        DatePicker("", selection: $date, in: Date()..., displayedComponents: .date)
            .datePickerStyle(.graphical)
            .accentColor(currentSchema.font)
            .labelsHidden()
            .padding(.horizontal)
            .background(currentSchema.background, in: RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
            .frame(width: 300)
            .frame(maxWidth: .infinity)
    }
}
