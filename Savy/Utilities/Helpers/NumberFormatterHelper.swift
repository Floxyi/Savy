//
//  NumberFormatterHelper.swift
//  Savy
//
//  Created by Florian Winkler on 13.02.25.
//

import Foundation

/// A helper class for formatting numbers, especially for displaying currency and large numbers in a readable format.
struct NumberFormatterHelper {
    /// A shared instance of the `NumberFormatterHelper` to be used across the app.
    static let shared = NumberFormatterHelper()

    private let formatter: NumberFormatter

    /// Initializes the helper with a preconfigured `NumberFormatter` for formatting currency and large numbers.
    private init() {
        formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.usesGroupingSeparator = true
    }

    /// Formats a number to a human-readable format for visible display, adding suffixes like "k" for thousands or "M" for millions.
    ///
    /// - Parameter number: The integer value to format.
    /// - Returns: A formatted string representation of the number with appropriate suffix.
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

    /// Formats a number into a currency format with appropriate suffixes (e.g., "k" for thousands, "M" for millions).
    ///
    /// - Parameter number: The integer value to format as currency.
    /// - Returns: A formatted string representation of the number with appropriate suffix.
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
