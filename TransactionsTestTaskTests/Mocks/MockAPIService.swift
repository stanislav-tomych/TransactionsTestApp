//
//  MockAPIService.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 06.01.2025.
//

@testable import TransactionsTestTask
import Foundation

final class MockAPIService: APIServiceProtocol {
    var fetchBitcoinRateCalled = false
    var result: Result<BitcoinRate, Error>?
    
    func fetchBitcoinRate() async throws -> BitcoinRate {
        fetchBitcoinRateCalled = true
        switch result {
        case .success(let rate):
            return rate
        case .failure(let error):
            throw error
        case .none:
            fatalError("Result not set in MockAPIService")
        }
    }
}
