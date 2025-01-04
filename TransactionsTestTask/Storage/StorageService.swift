//
//  StorageService.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//

protocol StorageService {
    func saveTransaction(_ transaction: Transaction)
    func fetchTransactions() -> [Transaction]
    var currentBalance: Double { get set }
}
