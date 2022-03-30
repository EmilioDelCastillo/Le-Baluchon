//
//  MockURLSession.swift
//  Le BaluchonTests
//
//  Created by Emilio Del Castillo on 15/03/2022.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    // Allows the subclass to handle the fake network tasks.
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    /// Starts the loading of the request
    override func startLoading() {
        guard let requestHandler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        
        do {
            let (response, data) = try requestHandler(request)
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    /// Stops the loading of the request
    override func stopLoading() {}
}
