//
//  PersistenceService.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//

import CoreData

class PersistenceService: DataService {
    private enum Keys {
        static let balanceEntity = "BalanceEntity"
        static let transactionEntity = "TransactionEntity"
        static let id = "id"
        static let date = "date"
        static let amount = "amount"
        static let category = "category"
        static let type = "type"
        static let balance = "balance"
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TransactionsTestTask")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    var currentBalance: Double {
        get {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Keys.balanceEntity)
            do {
                let results = try context.fetch(fetchRequest)
                return results.first?.value(forKey: Keys.balance) as? Double ?? 0.0
            } catch {
                print("Failed to fetch current balance: \(error)")
                return 0.0
            }
        }
        set {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Keys.balanceEntity)
            do {
                let results = try context.fetch(fetchRequest)
                if let balanceEntity = results.first {
                    balanceEntity.setValue(newValue, forKey: Keys.balance)
                } else {
                    let balanceEntity = NSEntityDescription.insertNewObject(forEntityName: Keys.balanceEntity, into: context)
                    balanceEntity.setValue(newValue, forKey: Keys.balance)
                }
                saveContext()
            } catch {
                print("Failed to update balance: \(error)")
            }
        }
    }

    func saveTransaction(_ transaction: Transaction) {
        let transactionEntity = NSEntityDescription.insertNewObject(forEntityName: Keys.transactionEntity, into: context)
        transactionEntity.setValue(transaction.id, forKey: Keys.id)
        transactionEntity.setValue(transaction.date, forKey: Keys.date)
        transactionEntity.setValue(transaction.amount, forKey: Keys.amount)
        transactionEntity.setValue(transaction.category.rawValue, forKey: Keys.category)
        transactionEntity.setValue(transaction.type.rawValue, forKey: Keys.type)

        currentBalance += transaction.amount
        saveContext()
    }

    func fetchTransactions(offset: Int, limit: Int) -> [Transaction] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Keys.transactionEntity)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Keys.date, ascending: false)]
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.compactMap { object in
                guard
                    let id = object.value(forKey: Keys.id) as? UUID,
                    let date = object.value(forKey: Keys.date) as? Date,
                    let amount = object.value(forKey: Keys.amount) as? Double,
                    let categoryRaw = object.value(forKey: Keys.category) as? Int16,
                    let category = TransactionCategory(rawValue: categoryRaw),
                    let typeRaw = object.value(forKey: Keys.type) as? Int16,
                    let type = TransactionType(rawValue: typeRaw)
                else {
                    return nil
                }
                return Transaction(id: id, date: date, amount: amount, category: category, type: type)
            }
        } catch {
            print("Failed to fetch transactions: \(error)")
            return []
        }
    }

    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
