//
//  BitcoinRateServiceTests.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 06.01.2025.
//

@testable import TransactionsTestTask
import XCTest
import Combine

final class BitcoinRateServiceTests: XCTestCase {
    var mockAPIService: MockAPIService!
    var bitcoinRateService: BitcoinRateService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        bitcoinRateService = BitcoinRateService(apiService: mockAPIService, refreshInterval: 1.0)
        cancellables = []
    }

    override func tearDown() {
        mockAPIService = nil
        bitcoinRateService = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchBitcoinRateSuccess() async throws {
        // Arrange
        let expectedRate = BitcoinRate(bpi: .init(USD: BitcoinRate.Bpi.Currency(rateFloat: 99009.2596)))
        mockAPIService.result = .success(expectedRate)

        // Act
        await bitcoinRateService.fetchBitcoinRate()

        // Assert
        XCTAssertTrue(mockAPIService.fetchBitcoinRateCalled)
        XCTAssertEqual(bitcoinRateService.currentRate, 99009.2596)
    }

    func testFetchBitcoinRateFailureLoadsCache() async throws {
        // Arrange
        let cachedRate = 45000.1234
        UserDefaults.standard.set(cachedRate, forKey: "lastBitcoinRate")
        mockAPIService.result = .failure(NSError(domain: "TestError", code: 1, userInfo: nil))

        // Act
        await bitcoinRateService.fetchBitcoinRate()

        // Assert
        XCTAssertTrue(mockAPIService.fetchBitcoinRateCalled)
        XCTAssertEqual(bitcoinRateService.currentRate, cachedRate)
    }

    func testStartFetchingRates() async throws {
        // Arrange
        let expectation = expectation(description: "Fetch called multiple times")
        expectation.expectedFulfillmentCount = 2

        let expectedRate = BitcoinRate(bpi: .init(USD: BitcoinRate.Bpi.Currency(rateFloat: 99009.2596)))
        mockAPIService.result = .success(expectedRate)

        bitcoinRateService.currentRatePublisher
            .sink { rate in
                if rate == 99009.2596 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Act
        bitcoinRateService.startFetchingRates()
        try? await Task.sleep(nanoseconds: 2_000_000_000) // Wait 2 seconds to simulate two fetch cycles

        // Assert
        await fulfillment(of: [expectation], timeout: 3)
    }

    func testStopFetchingRates() async throws {
        // Arrange
        let expectation = expectation(description: "Fetch stops after cancel")
        expectation.isInverted = true

        mockAPIService.result = .failure(NSError(domain: "TestError", code: 1, userInfo: nil))

        bitcoinRateService.currentRatePublisher
            .sink { rate in
                if rate != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Act
        bitcoinRateService.startFetchingRates()
        bitcoinRateService.stopFetchingRates()
        try? await Task.sleep(nanoseconds: 2_000_000_000) // Wait 2 seconds to verify no fetch happens

        // Assert
        await fulfillment(of: [expectation], timeout: 3)
    }
}
