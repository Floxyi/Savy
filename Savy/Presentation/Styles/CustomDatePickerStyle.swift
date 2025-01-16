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

struct CustomDatePickerOverlay: View {
    @Binding var date: Date
    var startDate: Date

    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    public var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        DatePicker("", selection: $date, in: startDate..., displayedComponents: .date)
            .datePickerStyle(.graphical)
            .accentColor(currentSchema.accent2)
            .labelsHidden()
            .padding(.horizontal)
            .background(
                currentSchema.mode == .light ? currentSchema.background : currentSchema.barIcons,
                        in: RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
            .frame(width: 300)
            .frame(maxWidth: .infinity)
    }
}

extension DateFormatter {
    static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}
