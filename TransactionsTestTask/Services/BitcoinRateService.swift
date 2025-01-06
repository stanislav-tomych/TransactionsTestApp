//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

/// Rate Service should fetch data from https://api.coindesk.com/v1/bpi/currentprice.json
/// Fetching should be scheduled with dynamic update interval
/// Rate should be cached for the offline mode
/// Every successful fetch should be logged with analytics service
/// The service should be covered by unit tests
//protocol BitcoinRateService: AnyObject {
//    
//    var onRateUpdate: ((Double) -> Void)? { get set }
//}
//
//final class BitcoinRateServiceImpl {
//    
//    var onRateUpdate: ((Double) -> Void)?
//    
//    // MARK: - Init
//    
//    init() {
//        
//    }
//}
//
//extension BitcoinRateServiceImpl: BitcoinRateService {
//    
//}

import Foundation
import Combine

protocol BitcoinRateServiceProtocol {
    var currentRatePublisher: Published<Double?>.Publisher { get }
    func startFetchingRates()
    func stopFetchingRates()
}

final class BitcoinRateService: BitcoinRateServiceProtocol {
    private let apiService: APIServiceProtocol
    private let userDefaults = UserDefaults.standard
    private var refreshInterval: TimeInterval

    private var timerTask: Task<Void, Never>?
    private var isTimerActive = false
    @Published private(set) var currentRate: Double?
    
    var currentRatePublisher: Published<Double?>.Publisher { $currentRate }

    init(apiService: APIServiceProtocol, refreshInterval: TimeInterval) {
        self.apiService = apiService
        self.refreshInterval = refreshInterval
    }

    func fetchBitcoinRate() async {
        do {
            let bitcoinRate = try await apiService.fetchBitcoinRate()
            currentRate = bitcoinRate.bpi.USD.rateFloat
            cacheRate(currentRate!)
        } catch {
            loadCachedRate()
            print("Failed to fetch Bitcoin rate: \(error)")
        }
    }
    
    func startFetchingRates() {
        guard !isTimerActive else { return }
        isTimerActive = true
        
        timerTask = Task {
            while !Task.isCancelled {
                await fetchBitcoinRate()
                try? await Task.sleep(nanoseconds: UInt64(refreshInterval * 1_000_000_000))
            }
        }
    }
    
    func stopFetchingRates() {
        timerTask?.cancel()
        timerTask = nil
        isTimerActive = false
    }
    
    private func cacheRate(_ rate: Double) {
        userDefaults.set(rate, forKey: Constants.rateKey)
    }
    
    private func loadCachedRate() {
        if let rate = userDefaults.value(forKey: Constants.rateKey) as? Double {
            currentRate = rate
        }
    }
        
    private enum Constants {
        static let rateKey = "lastBitcoinRate"
    }
}
