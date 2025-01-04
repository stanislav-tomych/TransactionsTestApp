//
//  Transaction.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//

import Foundation

enum TransactionCategory: Int16, CaseIterable, Codable {
    case groceries = 0
    case taxi = 1
    case electronics = 2
    case restaurant = 3
    case other = 4
    
    func toString() -> String {
        switch self {
        case .groceries:
            Localization.TransactionTypes.groceries
        case .taxi:
            Localization.TransactionTypes.taxi
        case .electronics:
            Localization.TransactionTypes.electronics
        case .restaurant:
            Localization.TransactionTypes.restaurant
        case .other:
            Localization.TransactionTypes.other
        }
    }
}

enum TransactionType: Int16, Codable {
    case expense = 0
    case adjunction = 1
}

struct Transaction: Identifiable {
    let id: UUID
    let date: Date
    let amount: Double
    let category: TransactionCategory
    let type: TransactionType
}
