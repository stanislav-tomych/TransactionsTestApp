//
//  PersistenceServiceTests.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 06.01.2025.
//

import XCTest
import CoreData
@testable import TransactionsTestTask

final class PersistenceServiceTests: XCTestCase {
    var persistenceService: PersistenceService!
    var mockContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        mockContainer = {
            let container = NSPersistentContainer(name: "TransactionsTestTask")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { _, error in
                XCTAssertNil(error, "Failed to set up in-memory Core Data stack: \(error!)")
            }
            return container
        }()

        persistenceService = PersistenceService(container: mockContainer)
    }

    override func tearDown() {
        persistenceService = nil
        mockContainer = nil
        super.tearDown()
    }

    func testCurrentBalanceDefault() {
        // Assert
        XCTAssertEqual(persistenceService.currentBalance, 0.0, "Default balance should be 0.0")
    }

    func testSaveAndRetrieveBalance() {
        // Arrange
        let newBalance: Double = 100.5

        // Act
        persistenceService.currentBalance = newBalance

        // Assert
        XCTAssertEqual(persistenceService.currentBalance, newBalance, "Failed to save or retrieve the correct balance")
    }

    func testSaveTransaction() {
        // Arrange
        let transaction = Transaction(
            id: UUID(),
            date: Date(),
            amount: 50.0,
            category: .groceries,
            type: .expense
        )

        // Act
        persistenceService.saveTransaction(transaction)

        // Assert
        let transactions = persistenceService.fetchTransactions(offset: 0, limit: 10)
        XCTAssertEqual(transactions.count, 1, "Should have one transaction saved")
        XCTAssertEqual(transactions.first?.amount, transaction.amount, "Transaction amount mismatch")
    }

    func testFetchTransactionsWithPagination() {
        // Arrange
        let transactions = (1...25).map { index in
            Transaction(
                id: UUID(),
                date: Date().addingTimeInterval(-Double(index * 60)),
                amount: Double(index * 10),
                category: .other,
                type: .adjunction
            )
        }
        transactions.forEach { persistenceService.saveTransaction($0) }

        // Act
        let firstBatch = persistenceService.fetchTransactions(offset: 0, limit: 10)
        let secondBatch = persistenceService.fetchTransactions(offset: 10, limit: 10)

        // Assert
        XCTAssertEqual(firstBatch.count, 10, "First batch size mismatch")
        XCTAssertEqual(secondBatch.count, 10, "Second batch size mismatch")
        XCTAssertEqual(firstBatch.first?.amount, transactions.first?.amount, "First batch data mismatch")
        XCTAssertEqual(secondBatch.first?.amount, transactions[10].amount, "Second batch data mismatch")
    }
}
