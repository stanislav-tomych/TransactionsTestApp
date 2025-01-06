//
//  AnalyticsEvent.swift
//  TransactionsTestTask
//
//

import Foundation

struct AnalyticsEvent {
    let name: AnalyticsEventName
    let parameters: [AnalyticsEventParameter: Any]
    let date: Date
}

// As this product is something like an MVP we will report only the most important events
// We are not going to report intents to fill the balance or create a transaction, only actions of them.
// We will also avoid application and viewcontroller lifecycle events of being reported same as buttons clicks
enum AnalyticsEventName: String {
    case transaction
    case adjuction
    case balanceUpdate
    case rateUpdate
    case transactionsPageLoaded
}

enum AnalyticsEventParameter: String {
    case transactionId
    case amount
    case date
    case category
    case count
    case offset
}

