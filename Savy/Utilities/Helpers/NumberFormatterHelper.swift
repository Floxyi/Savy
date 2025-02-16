//
//  NumberFormatterHelper.swift
//  Savy
//
//  Created by Florian Winkler on 13.02.25.
//

import Foundation

struct NumberFormatterHelper {
    static let shared = NumberFormatterHelper()

    private let formatter: NumberFormatter

    private init() {
        formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.usesGroupingSeparator = true
    }

    func formatVisibleCurrency(_ number: Int) -> String {
        let absNumber = abs(number)

        if absNumber >= 1_000_000 {
            let reduced = Double(absNumber) / 1_000_000
            return reduced.truncatingRemainder(dividingBy: 1) == 0 ? formatCurrency(number) : String(format: "%.1fM", reduced)
        }

        if absNumber >= 1000 {
            let reduced = Double(absNumber) / 1000
            return reduced.truncatingRemainder(dividingBy: 1) == 0 ? formatCurrency(number) : String(format: "%.1fk", reduced)
        }

        return "\(number)"
    }

    func formatCurrency(_ number: Int) -> String {
        let absNumber = abs(number)

        switch absNumber {
        case 1_000_000...:
            formatter.positiveSuffix = "M"
            return formatter.string(from: NSNumber(value: Double(number) / 1_000_000)) ?? "\(number)"
        case 1000...:
            formatter.positiveSuffix = "k"
            return formatter.string(from: NSNumber(value: Double(number) / 1000)) ?? "\(number)"
        default:
            formatter.positiveSuffix = ""
            return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
        }
    }
}
