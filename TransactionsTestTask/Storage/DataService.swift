//
//  DataService.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//

protocol DataService {
    func saveTransaction(_ transaction: Transaction)
    func fetchTransactions() -> [Transaction]
    var currentBalance: Double { get set }
}
