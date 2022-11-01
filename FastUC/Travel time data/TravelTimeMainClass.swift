//
//  TravelTimeMainClass.swift
//  FastUC
//
//  Created by Isha Nagireddy on 12/31/21.
//

import Foundation

// the overall travel time class
// contains destination address, origin address, rows, and a status
class TravelTime: Codable {
    var destination_address: [String]?
    var origin_address: [String]?
    var rows: [TravelTimeRows]?
    var status: String?
}
