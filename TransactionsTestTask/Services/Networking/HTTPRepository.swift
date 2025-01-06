//
//  HTTPRepository.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 05.01.2025.
//

import Foundation

protocol HTTPRepositoryProtocol: Sendable {
    func fetch<T: Decodable>(endpoint: Endpoints) async throws -> T
}

final class HTTPRepository: HTTPRepositoryProtocol {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetch<T: Decodable>(endpoint: Endpoints) async throws -> T {
        guard let url = endpoint.url else {
            throw APIErrors.invalidURL
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw APIErrors.invalidURL
        }
        
        components.queryItems = endpoint.queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = components.url else {
            throw APIErrors.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.allHTTPHeaderFields = endpoint.headers
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIErrors.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIErrors.decodingError
        }
    }
}
