//
//  APIErrors.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 05.01.2025.
//


enum APIErrors: Error, Equatable {
    case invalidURL
    case decodingError
    case serverError(statusCode: Int)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "errorInvalidUrl"
        case .decodingError:
            return "errorDecoding"
        case .serverError(let statusCode):
            return "errorServer" + "\(statusCode)."
        }
    }
}
