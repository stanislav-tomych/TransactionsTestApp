//
//  URLProtocolMock.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 06.01.2025.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    static var stubResponseData: Data?
    static var error: Error?
    static var response: HTTPURLResponse?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            let response = MockURLProtocol.response ?? HTTPURLResponse(url: request.url!,
                                                                       statusCode: 200,
                                                                       httpVersion: nil,
                                                                       headerFields: nil)!
            
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = MockURLProtocol.stubResponseData {
                self.client?.urlProtocol(self, didLoad: data)
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {}
}
