//
//  XCTestCase+Extension.swift
//  Le BaluchonTests
//
//  Created by Emilio Del Castillo on 30/03/2022.
//

import XCTest

extension XCTestCase {
    
    /// Retrieves data from a json file in the bundle.
    /// - Parameter name: The name of the file.
    /// - Returns: The data from the file.
    func getData(name: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: name, withExtension: "json")!
        let data = try! Data(contentsOf: fileUrl)
        return data
    }
}
