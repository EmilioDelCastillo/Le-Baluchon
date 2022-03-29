//
//  Double+Extension.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 10/03/2022.
//

import Foundation

extension Double {
    var string: String { String(self) }
    var roundedToInt: Int { Int(self.rounded()) }
}

extension Int {
    var string: String { String(self) }
}
