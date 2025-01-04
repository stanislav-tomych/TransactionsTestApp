//
//  TransactionsViewModel.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//

class TransactionsViewModel {
    private var onAddTransactionTapped: (() -> Void)?

    init(onAddTransactionTapped: (() -> Void)?) {
        self.onAddTransactionTapped = onAddTransactionTapped
    }
    
    func handleAddTransactionButtonTapped() {
        onAddTransactionTapped?()
    }
}
