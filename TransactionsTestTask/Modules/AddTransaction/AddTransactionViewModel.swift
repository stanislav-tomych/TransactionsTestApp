//
//  AddTransactionViewModel.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//

import Foundation
import Combine

final class AddTransactionViewModel {
    var dataService: DataServiceProtocol
    var analyticsService: AnalyticsServiceProtocol
    var onTransactionAdded: (() -> Void)?
    
    @Published var amountText: String = ""
    private(set) var isAddButtonEnabled: AnyPublisher<Bool, Never>!
    
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: DataServiceProtocol, analyticsService: AnalyticsServiceProtocol, onTransactionAdded: (() -> Void)?) {
        self.dataService = dataService
        self.analyticsService = analyticsService
        self.onTransactionAdded = onTransactionAdded
        
        isAddButtonEnabled = $amountText
            .map { text in
                guard text.toDouble() > 0 else {
                    return false
                }
                return true
            }
            .eraseToAnyPublisher()
    }

    func addTransaction(amount: Double, selectedCategory: TransactionCategory) {
        let transaction = Transaction(
            id: UUID(),
            date: Date(),
            amount: -amount,
            category: selectedCategory,
            type: .expense
        )
        dataService.saveTransaction(transaction)
        analyticsService.trackEvent(name: .transaction, parameters: [.transactionId : transaction.id, .amount: transaction.amount, .date: transaction.date, .category: transaction.category.toString()])
        onTransactionAdded?()
    }
}
