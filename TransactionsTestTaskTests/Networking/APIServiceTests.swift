//
//  TransactionsTestTask.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 06.01.2025.
//

import XCTest
@testable import TransactionsTestTask

final class APIServiceTests: XCTestCase {
    var mockHTTPRepository: MockHTTPRepository!
    var apiService: APIService!

    override func setUp() {
        super.setUp()
        mockHTTPRepository = MockHTTPRepository()
        apiService = APIService(httpRepository: mockHTTPRepository)
    }

    override func tearDown() {
        mockHTTPRepository = nil
        apiService = nil
        super.tearDown()
    }

    func testFetchBitcoinRateSuccess() async throws {
        // Arrange
        let testJSON = """
                  {"time":{"updated":"Jan 6, 2025 13:18:05 UTC","updatedISO":"2025-01-06T13:18:05+00:00","updateduk":"Jan 6, 2025 at 13:18 GMT"},"disclaimer":"This data was produced from the CoinDesk Bitcoin Price Index (USD). Non-USD currency data converted using hourly conversion rate from openexchangerates.org","chartName":"Bitcoin","bpi":{"USD":{"code":"USD","symbol":"&#36;","rate":"99,009.26","description":"United States Dollar","rate_float":99009.2596},"GBP":{"code":"GBP","symbol":"&pound;","rate":"78,957.904","description":"British Pound Sterling","rate_float":78957.9044},"EUR":{"code":"EUR","symbol":"&euro;","rate":"94,986.612","description":"Euro","rate_float":94986.6124}}}
        """.data(using: .utf8)!
        
        mockHTTPRepository.result = .success(testJSON)

        // Act
        let bitcoinRate = try await apiService.fetchBitcoinRate()

        // Assert
        XCTAssertTrue(mockHTTPRepository.fetchCalled)
        XCTAssertEqual(bitcoinRate.bpi.USD.rateFloat, 99009.2596)
    }

    func testFetchBitcoinRateFailure() async throws {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockHTTPRepository.result = .failure(expectedError)

        // Act & Assert
        do {
            _ = try await apiService.fetchBitcoinRate()
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertTrue(mockHTTPRepository.fetchCalled)
            XCTAssertEqual((error as NSError).code, expectedError.code)
        }
    }
}
