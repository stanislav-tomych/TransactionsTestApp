//
//  HTTPRepositoryTests.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 06.01.2025.
//

import XCTest
@testable import TransactionsTestTask

final class HTTPRepositoryTests: XCTestCase {
    var httpRepository: HTTPRepository!
    var urlSession: URLSession!

    override func setUp() {
        super.setUp()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        httpRepository = HTTPRepository(urlSession: urlSession)
    }

    override func tearDown() {
        httpRepository = nil
        urlSession = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
        MockURLProtocol.response = nil
        super.tearDown()
    }

    func testFetch_SuccessfulResponse() async throws {
        let expectedData = """
            {"time":{"updated":"Jan 6, 2025 13:18:05 UTC","updatedISO":"2025-01-06T13:18:05+00:00","updateduk":"Jan 6, 2025 at 13:18 GMT"},"disclaimer":"This data was produced from the CoinDesk Bitcoin Price Index (USD). Non-USD currency data converted using hourly conversion rate from openexchangerates.org","chartName":"Bitcoin","bpi":{"USD":{"code":"USD","symbol":"&#36;","rate":"99,009.26","description":"United States Dollar","rate_float":99009.2596},"GBP":{"code":"GBP","symbol":"&pound;","rate":"78,957.904","description":"British Pound Sterling","rate_float":78957.9044},"EUR":{"code":"EUR","symbol":"&euro;","rate":"94,986.612","description":"Euro","rate_float":94986.6124}}}
            """.data(using: .utf8)
        
        MockURLProtocol.stubResponseData = expectedData
        MockURLProtocol.response = HTTPURLResponse(url: Endpoints.bitcoinRate.url!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)
        let bitcoinRate: BitcoinRate = try await httpRepository.fetch(endpoint: .bitcoinRate)
        XCTAssertEqual(bitcoinRate.currentUSDRate(), 99009.2596)
    }

    func testFetch_ServerError() async {
        MockURLProtocol.response = HTTPURLResponse(url: Endpoints.bitcoinRate.url!,
                                                   statusCode: 500,
                                                   httpVersion: nil,
                                                   headerFields: nil)

        do {
            let _: BitcoinRate = try await httpRepository.fetch(endpoint: .bitcoinRate)
            XCTFail("Expected to throw an error but succeeded")
        } catch {
            if let apiError = error as? APIErrors {
                XCTAssertEqual(apiError, .serverError(statusCode: 500))
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        }
    }

    func testFetch_DecodingError() async {
        let invalidData = "Invalid JSON".data(using: .utf8)
        MockURLProtocol.stubResponseData = invalidData
        MockURLProtocol.response = HTTPURLResponse(url: Endpoints.bitcoinRate.url!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)

        do {
            let _: BitcoinRate = try await httpRepository.fetch(endpoint: .bitcoinRate)
            XCTFail("Expected to throw a decoding error but succeeded")
        } catch {
            if let apiError = error as? APIErrors {
                XCTAssertEqual(apiError, .decodingError)
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        }
    }
}
