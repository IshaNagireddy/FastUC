//
//  detailsView.swift
//  FastUC
//
//  Created by Isha Nagireddy on 12/25/21.
//

import UIKit
import MapKit

class detailsView: UIViewController {
    
    var selectedUC: UrgentCaresFinalInfo?
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var waitTimeLabel: UILabel!
    @IBOutlet weak var travelTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    override func viewDidLoad() {
        
        // make address user friendly
        let destinationLocation = CLLocation(latitude: selectedUC!.location!.latitude, longitude: selectedUC!.location!.longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(destinationLocation, completionHandler: {[weak self] (placemarks, error) in
            
            guard let self = self else {
                return
            }
            
            if let error = error {
                print("error: \(error)")
                return
            }
                
            guard let address = placemarks?.first else {
                print("error: ")
                return
            }
            
            let name = address.name
            let neighborhood = address.subLocality
            let city = address.locality
                
            DispatchQueue.main.async {
            self.locationLabel.text = "Location: \(name ?? ""), \(neighborhood ?? ""), \(city ?? "")"
            }
        })
        
        // print wait time
        waitTimeLabel.text = "Wait time: \((selectedUC!.waitTime)!) minutes"
        
        // print travel time
        travelTimeLabel.text = "Travel time: \((selectedUC!.travelTime)!) minutes"
        
        // print total time
        totalTimeLabel.text = "Total time: \((selectedUC!.totalTime)!) minutes"
        
        
    }
    
    @IBAction func getDirectionsClicked(_ sender: Any) {
        
        // create an alert asking users what platform they want the directions to be displayed on
        let alert = UIAlertController(title: "Getting directions", message: "Would you like the directions to be displayed in Apple Maps", preferredStyle: UIAlertController.Style.alert)
        
        // first option: apple maps
        // when user clicks this option, they are redirected to apple maps and a pin is placed on the destination
        let appleMaps = UIAlertAction(title: "Redirect to Apple Maps", style: UIAlertAction.Style.default, handler: {[self] action in
            
            let regionDistance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegion(center: (selectedUC?.location)!, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
            
            let placeMark = MKPlacemark(coordinate: selectedUC!.location!)
            let mapItem = MKMapItem(placemark: placeMark)
            mapItem.name = selectedUC!.name
            mapItem.openInMaps(launchOptions: options)
            
        })
        
        
        self.present(alert, animated: true, completion: nil)
        alert.addAction(appleMaps)
        
    }
    
}
