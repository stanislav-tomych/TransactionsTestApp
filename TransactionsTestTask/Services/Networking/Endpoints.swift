//
//  Endpoints.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 05.01.2025.
//

import Foundation

enum Endpoints {
    static let baseURL = "https://api.coindesk.com/v1/"
    
    case bitcoinRate
    
    var url: URL? {
        switch self {
        case .bitcoinRate:
            return URL(string: Endpoints.baseURL + path)
        }
    }
    
    private var path: String {
        switch self {
        case .bitcoinRate:
            return "bpi/currentprice.json"
        }
    }
    
    var method: String {
        switch self {
        case .bitcoinRate:
            return "GET"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .bitcoinRate:
            return ["Content-Type": "application/json"]
        }
    }
    
    var queryParameters: [String: String] {
        switch self {
        case .bitcoinRate:
            return [:]
        }
        
    }
}
