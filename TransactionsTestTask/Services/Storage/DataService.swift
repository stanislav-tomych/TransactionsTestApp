//
//  DataServiceProtocol.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//

protocol DataServiceProtocol {
    func saveTransaction(_ transaction: Transaction)
    func fetchTransactions(offset: Int, limit: Int) -> [Transaction]
    var currentBalance: Double { get set }
}
