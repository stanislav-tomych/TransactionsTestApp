//
//  HTTPRepositoryMock.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 06.01.2025.
//

@testable import TransactionsTestTask
import Foundation

final class MockHTTPRepository: HTTPRepositoryProtocol, @unchecked Sendable  {
    private(set) var fetchCalled = false
    var result: Result<Data, Error>?

    func fetch<T>(endpoint: Endpoints) async throws -> T where T : Decodable {
        fetchCalled = true
        guard let result = result else {
            fatalError("Mock result not set")
        }
        
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        case .failure(let error):
            throw error
        }
    }
}
