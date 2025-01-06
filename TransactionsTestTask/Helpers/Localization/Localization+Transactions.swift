//
//  Localization+Transactions.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//

import Foundation

extension Localization {
    enum AddTransactions {
        static let enterAmount = NSLocalizedString("AddTransaction.Textfield.Placeholder", comment: "")
        static let addButtonTitle = NSLocalizedString("AddTransaction.AddButton.Title", comment: "")
        static let navigationTitle = NSLocalizedString("AddTransaction.NavigationBar.Title", comment: "")
    }
    
    enum Transactions {
        static let fillBalanceTitle = NSLocalizedString("Transactions.FillBalanceAlert.Title", comment: "")
        static let fillBalancePlaceholder = NSLocalizedString("Transactions.FillBalanceAlert.Placeholder", comment: "")
        static let navigationTitle = NSLocalizedString("Transactions.NavigationBar.Title", comment: "")
        static let bitcoinViewTitle = NSLocalizedString("Transactions.BitcoinView.Title", comment: "")
    }
    
    enum TransactionTypes {
        static let groceries = NSLocalizedString("TransactionTypes.Grocery", comment: "")
        static let taxi = NSLocalizedString("TransactionTypes.Taxi", comment: "")
        static let electronics = NSLocalizedString("TransactionTypes.Electronics", comment: "")
        static let restaurant = NSLocalizedString("TransactionTypes.Restaurant", comment: "")
        static let other = NSLocalizedString("TransactionTypes.Other", comment: "")
        
        static let adjunction = NSLocalizedString("TransactionTypes.Adjunction", comment: "")
        static let expense = NSLocalizedString("TransactionTypes.Expense", comment: "")
    }
}
