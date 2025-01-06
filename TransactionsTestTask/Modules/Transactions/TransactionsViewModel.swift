//
//  TransactionsViewModel.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//
import Combine
import Foundation

final class TransactionsViewModel {
    private let dataService: DataServiceProtocol
    private let bitcoinRateService: BitcoinRateServiceProtocol
    private let analyticsService: AnalyticsServiceProtocol

    private var onAddTransactionTapped: (() -> Void)?
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var transactionsSections: [TransactionsSection] = []
    @Published private(set) var currentBalance: Double = 0
    @Published var bitcoinRate: String = Constants.defaultBitcoinRateValue

    private var loadedTransactions: [Transaction] = []
    private var blockFetching: Bool = false

    init(dataService: DataServiceProtocol, bitcoinRateService: BitcoinRateServiceProtocol, analyticsService: AnalyticsServiceProtocol, onAddTransactionTapped: (() -> Void)?) {
        self.dataService = dataService
        self.onAddTransactionTapped = onAddTransactionTapped
        self.analyticsService = analyticsService
        self.bitcoinRateService = bitcoinRateService
        bindToBitcoinRateService()
        bitcoinRateService.startFetchingRates()
    }
    
    func fetchTransactions(refetchAll: Bool = false) {
        if refetchAll {
            loadedTransactions = []
            blockFetching = false
        }
        
        guard !blockFetching else { return }
        blockFetching = true
        
        let offset = loadedTransactions.count
        let newTransactions = dataService.fetchTransactions(offset: loadedTransactions.count, limit: Constants.batchSize)
        if newTransactions.count != 0 {
            loadedTransactions.append(contentsOf: newTransactions)
            
            let groupedTransactions = Dictionary(grouping: loadedTransactions, by: { Calendar.current.startOfDay(for: $0.date) })
            transactionsSections = groupedTransactions.map { TransactionsSection(date: $0.key, transactions: $0.value) }
                .sorted(by: { $0.date > $1.date })
            currentBalance = dataService.currentBalance
            blockFetching = false
            
            analyticsService.trackEvent(name: .transactionsPageLoaded, parameters: [.count: newTransactions.count, .offset: offset])
            analyticsService.trackEvent(name: .balanceUpdate, parameters: [.amount: currentBalance])
        }
    }

    private func bindToBitcoinRateService() {
        bitcoinRateService.currentRatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rate in
                var rateString = Constants.defaultBitcoinRateValue
                if let rate = rate {
                    rateString = String(format: "$%.4f", rate)
                }
                
                self?.bitcoinRate = rateString
                self?.analyticsService.trackEvent(name: .rateUpdate, parameters: [.amount: rateString])
            }
            .store(in: &cancellables)
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
        analyticsService.trackEvent(name: .adjuction, parameters: [.transactionId: transaction.id, .date: transaction.date, .amount: transaction.amount])
        fetchTransactions(refetchAll: true)
    }
    
    private enum Constants {
        static let batchSize: Int = 20
        static let defaultBitcoinRateValue: String = "??"
    }
    
    deinit {
        bitcoinRateService.stopFetchingRates()
    }
}
