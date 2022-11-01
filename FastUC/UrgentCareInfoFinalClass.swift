//
//  UrgentCareInfoFinalClass.swift
//  FastUC
//
//  Created by Isha Nagireddy on 12/31/21.
//

import Foundation
import CoreLocation

// class in which final urgent care info is stored
class UrgentCaresFinalInfo {
    
    var name: String?
    var location: CLLocationCoordinate2D?
    var travelTime: Int?
    var waitTime: Int?
    var totalTime: Int?
    
    init (initName: String, initLocation: CLLocationCoordinate2D, initTravelTime: Int, initWaitTime: Int, initTotalTime: Int){
        
        name = initName
        location = initLocation
        travelTime = initTravelTime
        waitTime = initWaitTime
        totalTime = initTotalTime
    }
}
