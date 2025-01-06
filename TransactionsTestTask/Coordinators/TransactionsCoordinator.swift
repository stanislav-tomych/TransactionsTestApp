//
//  TransactionsCoordinator.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//

import UIKit

final class TransactionsCoordinator: Coordinator {
    private let navigationController: UINavigationController
    
    private var dataService: DataServiceProtocol
    private var bitcoinRateService: BitcoinRateServiceProtocol
    private var apiService: APIServiceProtocol
    private var analyticsService: AnalyticsServiceProtocol

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let httpRepository = HTTPRepository()
        self.apiService = APIService(httpRepository: httpRepository)
        self.bitcoinRateService = BitcoinRateService(apiService: apiService, refreshInterval: Constants.bitcoinRefreshInterval)
        self.dataService = PersistenceService()
        self.analyticsService = AnalyticsService()
    }

    func start() {
        let transactionViewModel = TransactionsViewModel(dataService: dataService, bitcoinRateService: bitcoinRateService, analyticsService: analyticsService) { [weak self] in
            self?.showAddTransaction()
        }
        let transactionsViewController = TransactionsViewController(viewModel: transactionViewModel)
        navigationController.viewControllers = [transactionsViewController]
    }
    
    private func showAddTransaction() {
        let viewModel = AddTransactionViewModel(dataService: dataService, analyticsService: analyticsService) { [weak self] in
            self?.pop()
        }
        let addTransactionViewController = AddTransactionViewController(viewModel: viewModel)
        navigationController.pushViewController(addTransactionViewController, animated: true)
    }
    
    private func pop() {
        navigationController.popViewController(animated: true)
    }
    
    private enum Constants {
        static let bitcoinRefreshInterval = 120.0
    }
}
