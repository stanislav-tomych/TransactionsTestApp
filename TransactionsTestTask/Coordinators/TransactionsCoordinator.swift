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

    private var transactionsViewController: TransactionsViewController?
    private var addTransactionViewController: AddTransactionViewController?

    init(navigationController: UINavigationController, dataService: DataServiceProtocol) {
        self.navigationController = navigationController
        self.dataService = dataService
        
        let httpRepository = HTTPRepository()
        self.apiService = APIService(httpRepository: httpRepository)
        self.bitcoinRateService = BitcoinRateService(apiService: apiService, refreshInterval: 10)
    }

    func start() {
        let transactionViewModel = TransactionsViewModel(dataService: dataService, bitcoinRateService: bitcoinRateService) { [weak self] in
            self?.showAddTransaction()
        }
        let transactionsViewController = TransactionsViewController(viewModel: transactionViewModel)
        self.transactionsViewController = transactionsViewController
        navigationController.viewControllers = [transactionsViewController]
    }
    
    private func showAddTransaction() {
        let viewModel = AddTransactionViewModel(dataService: dataService) { [weak self] in
            self?.pop()
        }
        let addTransactionViewController = AddTransactionViewController(viewModel: viewModel)
        navigationController.pushViewController(addTransactionViewController, animated: true)
    }
    
    private func pop() {
        navigationController.popViewController(animated: true)
    }
}
