//
//  AppCoordinator.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//

import UIKit

class AppCoordinator: Coordinator {
    private let window: UIWindow
    private var navigationController: UINavigationController?
    private var dataService: DataServiceProtocol = PersistenceService()
    private var transactionsCoordinator: TransactionsCoordinator?
    
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        let transactionsCoordinator = TransactionsCoordinator(navigationController: navigationController, dataService: dataService)
        self.transactionsCoordinator = transactionsCoordinator
        transactionsCoordinator.start()
    }
}
