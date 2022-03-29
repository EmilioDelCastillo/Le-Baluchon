//
//  MockURLSession.swift
//  Le BaluchonTests
//
//  Created by Emilio Del Castillo on 15/03/2022.
//

import Foundation
@testable import Le_Baluchon

class MockURLSession: URLSessionProtocol {
    var data = Data()
    var response = URLResponse()
    var fail = false
    
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        if fail {
            throw NSError()
        } else {
            return (data, response)
        }
    }
}
