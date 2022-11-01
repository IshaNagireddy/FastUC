//
//  TravelTimeRowsClass.swift
//  FastUC
//
//  Created by Isha Nagireddy on 12/31/21.
//

import Foundation

// class for each row in JSON returned data
// contains an array of elements
class TravelTimeRows: Codable {
    var elements: [TravelTimeElements]?
}
