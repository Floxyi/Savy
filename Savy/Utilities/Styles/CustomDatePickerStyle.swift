//
//  CustomDatePickerStyle.swift
//  Savy
//
//  Created by Florian Winkler on 25.09.24.
//

import SwiftUI

struct CustomDatePickerStyle: DatePickerStyle {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var date: Date
    var text: String
    @Binding var isDatePickerVisible: Bool

    func makeBody(configuration _: Configuration) -> some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        HStack {
            Text(text)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(currentScheme.font.opacity(0.4))
            Spacer()
            Text(date, formatter: DateFormatter.customFormatter)
                .foregroundStyle(currentScheme.font)
                .font(.body)
                .padding(4)
                .padding(.horizontal, 6)
                .background(currentScheme.accent1)
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
    @Binding var startDate: Date

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    public var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        DatePicker("", selection: $date, in: startDate..., displayedComponents: .date)
            .datePickerStyle(.graphical)
            .accentColor(currentScheme.accent2)
            .labelsHidden()
            .padding(.horizontal)
            .background(
                currentScheme.mode == .light ? currentScheme.background : currentScheme.barIcons,
                in: RoundedRectangle(cornerRadius: 20)
            )
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
