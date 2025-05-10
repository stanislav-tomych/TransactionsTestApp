//
//  APIService.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 05.01.2025.
//

protocol APIServiceProtocol {
    func fetchBitcoinRate() async throws -> BitcoinRate
}

final class APIService: APIServiceProtocol {
    private let httpRepository: HTTPRepositoryProtocol
    
    init(httpRepository: HTTPRepositoryProtocol) {
        self.httpRepository = httpRepository
    }
    
    func fetchBitcoinRate() async throws -> BitcoinRate {
        try await httpRepository.fetch(endpoint: .bitcoinRate)
    }
}
