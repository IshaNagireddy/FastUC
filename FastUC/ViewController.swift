//
//  ViewController.swift
//  FastUC
//
//  Created by Isha Nagireddy on 12/25/21.
//

// image citations:
// <a href="https://www.flaticon.com/free-icons/daily-health-app" title="daily health app icons">Daily health app icons created by Freepik - Flaticon</a>
// <a href="https://www.flaticon.com/free-icons/surgeon" title="surgeon icons">Surgeon icons created by Freepik - Flaticon</a>
// <a href="https://www.flaticon.com/free-icons/hospital" title="hospital icons">Hospital icons created by Freepik - Flaticon</a>
// <a href="https://www.flaticon.com/free-icons/hospital" title="hospital icons">Hospital icons created by Freepik - Flaticon</a>

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, ObservableObject {
     
    var locationManager: CLLocationManager?
    var generalUserLocation: CLLocation?
    var userLocation: CLLocationCoordinate2D?
    var careType: String?
    
    override func viewDidLoad() {
        
        // check if useer services are enabled
        checkLocationServicesEnabled()
        super.viewDidLoad()
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        
        careType = "Urgent Care"
        
        // if user location is obtained stop updating the location
        // segue into the next screen
        if userLocation != nil {
            
            locationManager?.stopUpdatingLocation()
            print("USER LOCATION: \(userLocation!.latitude), \(userLocation!.longitude)")
            performSegue(withIdentifier: "toTopTenList", sender: nil)
        }
        
        // otherwise, check if location services are enabled again
        else {
            
            checkLocationServicesEnabled()
        }
    }
    
    
    @IBAction func emergencyRoomsClicked(_ sender: Any) {
        
        careType = "Emergency Room"
        
        if userLocation != nil {
            
            locationManager?.stopUpdatingLocation()
            print("USER LOCATION: \(userLocation!.latitude), \(userLocation!.longitude)")
            performSegue(withIdentifier: "toTopTenList", sender: nil)
        }
        
        // otherwise, check if location services are enabled again
        else {
            
            checkLocationServicesEnabled()
        }
        
    }
    
    func checkLocationServicesEnabled() {
        
        // if location services are enabled, create locationManager
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            // location authoriation will be called by default right here
        }
        
        // if location services are not enabled, inform the user
        else {
            
            print("Show an alert stating locations services are not enabled")
        }
    }
    
    func checkLocationAuthorization() {
        
        // make sure location services are enabled
        if locationManager == nil {
            return
        }
        
        // switch statements for different scenarios of authorization
        switch locationManager?.authorizationStatus {
            
            // if authorization is not determined, request location when app is in use
            case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
            
            // if location is restricted, inform user through an alert (most likely due to parental restrictions)
            case .restricted:
            
            let restrictedAlert = UIAlertController(title: "Restricted Access", message: "FastUC cannot access your location because of a restriction. This is most likely related to parental resetrictions.", preferredStyle: UIAlertController.Style.alert)
            let restrictedAlertOk = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
            
            self.present(restrictedAlert, animated: true, completion: nil)
            restrictedAlert.addAction(restrictedAlertOk)
            
            // if authorization request is denied, inform user through alert
            case .denied:
            let deniedAlert = UIAlertController(title: "Denied Access", message: "FastUC cannot access your location because it was denied.", preferredStyle: UIAlertController.Style.alert)
            let deniedAlertOk = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
            
            self.present(deniedAlert, animated: true, completion: nil)
            deniedAlert.addAction(deniedAlertOk)
            
            // if authorization is enabled when in use or always, start updating location
            case .authorizedAlways, .authorizedWhenInUse:
            locationManager!.startUpdatingLocation()
            
            @unknown default:
            break
        }
    }
    
    // if authorization is changed in any way, check location authorization once again
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    // when segueing to next screen, take user location
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTopTenList" {
            
            let destination = segue.destination as! topTenList
            destination.finalizedUserLocation = userLocation
            destination.finalizedCareType = careType
            
        }
    }
    
    // as the user's location updates, update the userLocation variable
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location.coordinate
        }
    }

}
