//
//  TransactionsCoordinator.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//

import UIKit

class TransactionsCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var transactionsViewController: TransactionsViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let transactionsViewController = TransactionsViewController()
        self.transactionsViewController = transactionsViewController
        navigationController.viewControllers = [transactionsViewController]
    }
}
