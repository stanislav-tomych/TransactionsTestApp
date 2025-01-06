//
//  AnalyticsServiceTests.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 06.01.2025.
//

import XCTest
@testable import TransactionsTestTask

final class AnalyticsServiceTests: XCTestCase {
    var analyticsService: AnalyticsService!

    override func setUp() {
        super.setUp()
        analyticsService = AnalyticsService()
    }

    override func tearDown() {
        analyticsService = nil
        super.tearDown()
    }

    func testTrackEvent() {
        // Arrange
        let eventName = AnalyticsEventName.transaction
        let parameters: [AnalyticsEventParameter: Any] = [
            .amount: 50.0,
            .category: "Groceries"
        ]

        // Act
        analyticsService.trackEvent(name: eventName, parameters: parameters)

        // Assert
        let events = analyticsService.getEvents()
        XCTAssertEqual(events.count, 1, "There should be exactly one event tracked.")
        XCTAssertEqual(events.first?.name, eventName, "The tracked event name should match.")
        XCTAssertEqual(events.first?.parameters[.amount] as? Double, 50.0, "The amount should match.")
    }

    func testGetEventsByName() {
        // Arrange
        analyticsService.trackEvent(name: .transaction, parameters: [:])
        analyticsService.trackEvent(name: .balanceUpdate, parameters: [:])

        // Act
        let filteredEvents = analyticsService.getEvents(name: .transaction)

        // Assert
        XCTAssertEqual(filteredEvents.count, 1, "There should be exactly one event with the specified name.")
        XCTAssertEqual(filteredEvents.first?.name, .transaction, "The filtered event name should match.")
    }

    func testGetEventsByDateRange() {
        // Arrange
        let now = Date()
        let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let futureDate = Calendar.current.date(byAdding: .day, value: 1, to: now)!
        
        analyticsService.trackEvent(name: .transaction, parameters: [:])
        analyticsService.trackEvent(name: .balanceUpdate, parameters: [:])

        // Act
        let filteredEvents = analyticsService.getEvents(startDate: pastDate, endDate: futureDate)

        // Assert
        XCTAssertEqual(filteredEvents.count, 2, "All events should be in the date range.")
    }

    func testGetEventsWithNoFilters() {
        // Arrange
        analyticsService.trackEvent(name: .transaction, parameters: [:])
        analyticsService.trackEvent(name: .balanceUpdate, parameters: [:])

        // Act
        let events = analyticsService.getEvents()

        // Assert
        XCTAssertEqual(events.count, 2, "There should be two events.")
    }
}
