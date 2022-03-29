//
//  URLSession+Extension.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 15/03/2022.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
