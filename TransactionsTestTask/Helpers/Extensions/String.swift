//
//  String.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 05.01.2025.
//

extension String {
    func toDouble() -> Double {
        return Double(replacingOccurrences(of: ",", with: ".")) ?? 0.0
    }
}
