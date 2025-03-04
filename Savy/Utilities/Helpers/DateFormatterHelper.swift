//
//  DateFormatterHelper.swift
//  Savy
//
//  Created by Nadine Schatz on 27.02.25.
//

import Foundation

struct DateFormatterHelper {
    static let shared = DateFormatterHelper()

    private let formatter: DateFormatter

    private init() {
        formatter = DateFormatter()
        formatter.dateFormat = "d.M.yy"
    }

    func formatDate(_ date: Date) -> String {
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
}
