//
//  CustomDatePickerStyle.swift
//  Savy
//
//  Created by Florian Winkler on 25.09.24.
//

import SwiftUI

struct CustomDatePickerStyle: DatePickerStyle {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var date: Date
    var text: String
    @Binding var isDatePickerVisible: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        HStack {
            Text(text)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(currentSchema.font.opacity(0.4))
            Spacer()
            Text(date, formatter: DateFormatter.customFormatter)
                .foregroundStyle(currentSchema.font)
                .font(.body)
                .padding(4)
                .padding(.horizontal, 6)
                .background(currentSchema.accent1)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .onTapGesture {
                    withAnimation {
                        isDatePickerVisible.toggle()
                    }
                }
        }
    }
}

extension DateFormatter {
    static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}
