//
//  AddTransactionViewModel.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//

import Foundation
import Combine

class AddTransactionViewModel {
    var dataService: DataServiceProtocol
    var onTransactionAdded: (() -> Void)?
    
    @Published var amountText: String = ""
    private(set) var isAddButtonEnabled: AnyPublisher<Bool, Never>!
    
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: DataServiceProtocol, onTransactionAdded: (() -> Void)?) {
        self.dataService = dataService
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
        onTransactionAdded?()
    }
}
