//
//  TransactionsViewModel.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//
import Combine
import Foundation

class TransactionsViewModel {
    private let dataService: DataService
    private var onAddTransactionTapped: (() -> Void)?
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var transactions: [Transaction] = []
    @Published private(set) var currentBalance: Double = 0

    init(dataService: DataService, onAddTransactionTapped: (() -> Void)?) {
        self.dataService = dataService
        self.onAddTransactionTapped = onAddTransactionTapped
    }

    func fetchTransactions() {
        Just(dataService.fetchTransactions())
            .sink { [weak self] fetchedTransactions in
                self?.transactions = fetchedTransactions
            }
            .store(in: &cancellables)
        
        currentBalance = dataService.currentBalance
    }

    func handleAddTransactionButtonTapped() {
        onAddTransactionTapped?()
    }
    
    func addBalance(amount: Double) {
        let transaction = Transaction(
            id: UUID(),
            date: Date(),
            amount: amount,
            category: .other,
            type: .adjunction
        )
        dataService.saveTransaction(transaction)
        fetchTransactions()
    }
}
