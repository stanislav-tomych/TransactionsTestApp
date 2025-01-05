//
//  BitcoinRate.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 05.01.2025.
//

struct BitcoinRate: Decodable {
    struct Bpi: Decodable {
        struct Currency: Decodable {
            let rateFloat: Double

            enum CodingKeys: String, CodingKey {
                case rateFloat = "rate_float"
            }
        }

        let USD: Currency
    }

    let bpi: Bpi
    
    func currentUSDRate() -> Double {
        bpi.USD.rateFloat
    }
}
