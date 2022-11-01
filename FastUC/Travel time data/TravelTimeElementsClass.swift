//
//  TravelTimeElementsClass.swift
//  FastUC
//
//  Created by Isha Nagireddy on 12/31/21.
//

import Foundation

// class for each element in JSON returned data
// contains duration in traffic, distance, duration, and status
class TravelTimeElements: Codable {
    var duration_in_traffic: TravelTimeDistanceDuration?
    var distance: TravelTimeDistanceDuration?
    var duration: TravelTimeDistanceDuration?
    var status: String?
}
