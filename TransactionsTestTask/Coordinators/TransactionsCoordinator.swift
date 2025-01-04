//
//  TransactionsCoordinator.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//

import UIKit

class TransactionsCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var dataService: DataService
    
    private var transactionsViewController: TransactionsViewController?
    private var addTransactionViewController: AddTransactionViewController?

    init(navigationController: UINavigationController, dataService: DataService) {
        self.navigationController = navigationController
        self.dataService = dataService
    }

    func start() {
        let transactionViewModel = TransactionsViewModel { [weak self] in
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
