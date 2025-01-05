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
    
    @Published private(set) var transactionsSections: [TransactionsSection] = []
    @Published private(set) var currentBalance: Double = 0

    private var allTransactions: [Transaction] = []
    private var loadedTransactions: [Transaction] = []
    private var isFetching: Bool = false
    
    init(dataService: DataService, onAddTransactionTapped: (() -> Void)?) {
        self.dataService = dataService
        self.onAddTransactionTapped = onAddTransactionTapped
    }
    
    func fetchTransactions() {
        guard !isFetching else { return }
        isFetching = true
        
        let newTransactions = dataService.fetchTransactions(offset: loadedTransactions.count, limit: Constants.batchSize)
        if newTransactions.count != 0 {
            allTransactions.append(contentsOf: newTransactions)
            loadedTransactions.append(contentsOf: newTransactions)
            
            let groupedTransactions = Dictionary(grouping: loadedTransactions, by: { Calendar.current.startOfDay(for: $0.date) })
            transactionsSections = groupedTransactions.map { TransactionsSection(date: $0.key, transactions: $0.value) }
                .sorted(by: { $0.date > $1.date })
            currentBalance = dataService.currentBalance
            
            isFetching = false
        }
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
    
    enum Constants {
        static let batchSize = 20
    }
}
