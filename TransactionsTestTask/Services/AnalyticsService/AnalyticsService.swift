//
//  AnalyticsService.swift
//  TransactionsTestTask
//
//

import Foundation

/// Analytics Service is used for events logging
/// The list of reasonable events is up to you
/// It should be possible not only to track events but to get it from the service
/// The minimal needed filters are: event name and date range
/// The service should be covered by unit tests
protocol AnalyticsServiceProtocol {
    func trackEvent(name: AnalyticsEventName, parameters: [AnalyticsEventParameter: Any])
    func getEvents(name: AnalyticsEventName?, startDate: Date?, endDate: Date?) -> [AnalyticsEvent]
}

final class AnalyticsService {
    private var events: [AnalyticsEvent] = []
}

extension AnalyticsService: AnalyticsServiceProtocol {

    func trackEvent(name: AnalyticsEventName, parameters: [AnalyticsEventParameter: Any]) {
        let event = AnalyticsEvent(
            name: name,
            parameters: parameters,
            date: .now
        )
        
        events.append(event)
        print("LOG EVENT")
        print("Name: \(event.name.rawValue)")
        for (key, value) in parameters {
            print("\(key): \(value)")
        }
        print("Date: \(event.date)")
        print("END")
    }
    
    func getEvents(name: AnalyticsEventName? = nil, startDate: Date? = nil, endDate: Date? = nil) -> [AnalyticsEvent] {
        return events.filter { event in
            let matchesName = name == nil || event.name == name
            let matchesStartDate = startDate == nil || event.date >= startDate!
            let matchesEndDate = endDate == nil || event.date <= endDate!
            return matchesName && matchesStartDate && matchesEndDate
        }
    }
}
