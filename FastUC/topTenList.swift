//
//  topTenList.swift
//  FastUC
//
//  Created by Isha Nagireddy on 12/25/21.
//

import GoogleMaps
import UIKit
import CoreLocation
import CoreData

class topTenList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // ui table view
    @IBOutlet weak var tableView: UITableView!
    
    // reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // finalized information from the previous view
    var finalizedUserLocation: CLLocationCoordinate2D?
    var finalizedCareType: String?
    
    // final array of top ten urgent cares after caculations
    var topTen = [UrgentCaresFinalInfo]()
    
    // the urgent care that a user clicks on to segue into the next screen
    var chosenUC: UrgentCaresFinalInfo?
    
    // all of the final urgent care data in one array
    var urgentCares = [UrgentCaresFinalInfo]()
    
    // the data of the urgent cares directly from core data
    var urgentCaresData = [UrgentCareInfo]()
    
    // trvael time to a certain urgent care
    var travelTimeNumeric: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view appears
        tableView.delegate = self
        tableView.dataSource = self
        
        // title of table view
        if finalizedCareType == "Urgent Care" {
            navigationItem.title = "Fastest Urgent Cares From You"
            
        }
        
        else {
            navigationItem.title = "Fastest Emergency Rooms From You"
        }
        
        // calculating top ten urgent cares
        createTopTen()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // the text of the cell will be the name of an urgent care
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row + 1). \(topTen[indexPath.row].name!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return 10
        return topTen.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // when cell is clicked on assign urgent care contained in cell as chosen UC
        chosenUC = topTen[indexPath.row]
        
        // when a cell is clicked on, segue to the details view
        performSegue(withIdentifier: "toDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // when about to segue to details view, take data for the chosen UC to the next screen
        if segue.identifier == "toDetails" {
            let location = segue.destination as! detailsView
            location.selectedUC = chosenUC
        }
    }
    
    func gatheringData(iteration: Int, completion2: @escaping() -> Void) {
        
        let userLatitude = finalizedUserLocation!.latitude
        let userLongitude = finalizedUserLocation!.longitude
        
        let apiKey = "AIzaSyC7JoQVi1K1DkccGvMil5AdestUpr8VCWg"
        
        let destinationLatitude = urgentCaresData[iteration].latitude
        let destinationLongitude = urgentCaresData[iteration].longitude
        
        // url
        let urlString = "https://maps.googleapis.com/maps/api/distancematrix/json?departure_time=now&destinations=\(destinationLatitude)%2C\(destinationLongitude)&origins=\(userLatitude)%2C\(userLongitude)&key=\(apiKey)"
        
        let url = URL(string: urlString)
        
        // making sure url is not nil
        guard url != nil else {
            print("Error creating url object")
            return
        }
        
        // making sure there are no errors and data is returned when the session is run
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error == nil && data != nil {
                
                // parse JSON
                let decoder = JSONDecoder()
                do {
                    
                    let travelTimeData = try decoder.decode(TravelTime.self, from: data!)
                    let rows = travelTimeData.rows![0]
                    let elements = rows.elements![0]
                    let travelTime = elements.duration_in_traffic
                    self.travelTimeNumeric = Int(exactly: travelTime!.value! / 60)!
                    
                    let waitTime = Int.random(in: 0..<121)
                    let totalTime = waitTime + self.travelTimeNumeric!
                    
                    let urgentCare = UrgentCaresFinalInfo(initName: self.urgentCaresData[iteration].name!, initLocation: CLLocationCoordinate2D(latitude: self.urgentCaresData[iteration].latitude, longitude: self.urgentCaresData[iteration].longitude), initTravelTime: self.travelTimeNumeric!, initWaitTime: waitTime, initTotalTime: totalTime)
                    self.urgentCares.append(urgentCare)
                    completion2()
                }
                
                catch {
                    print("Error in JSON parsing")
                }
                
            }
            
        }
        
        // Make the API call
        dataTask.resume()
        
    }
    
    func createTopTen() {
        let length: Int?
        var counter = 0
        do {
            
            // fetch urgent care data
            
            let request = UrgentCareInfo.fetchRequest()
            let pred = NSPredicate(format: "type CONTAINS %@", finalizedCareType!)
            
            request.predicate = pred
            urgentCaresData = try context.fetch(request)
            
            length = urgentCaresData.count
            
            for iteration in 0...(length! - 1) {
                gatheringData(iteration: iteration, completion2: {
                    
                    counter += 1
                    if counter == length {
                        for i in 0...(length! - 1) {
                            let name = self.urgentCares[i].name
                            let location = self.urgentCares[i].location
                            let travelTime = self.urgentCares[i].travelTime
                            let waitTime = self.urgentCares[i].waitTime
                            let totalTime = self.urgentCares[i].totalTime
                            
                            print("name: \(name!), location: \(location!.latitude) \(location!.longitude), travel time: \(travelTime!), wait time: \(waitTime!), total time: \(totalTime!)")
                            
                        }
                        self.urgentCares.sort {
                            $0.totalTime! < $1.totalTime!
                        }
                        
                        print("TOP TEN")
                        
                        for i in 0...9 {
                            self.topTen.append(self.urgentCares[i])
                            
                            let toptenName = self.topTen[i].name
                            let toptenLocation = self.topTen[i].location
                            let toptenTravelTime = self.topTen[i].travelTime
                            let toptenWaitTime = self.topTen[i].waitTime
                            let toptenTotalTime = self.topTen[i].totalTime

                            print("name: \(toptenName!), location: \(toptenLocation!.latitude) \(toptenLocation!.longitude), travel time: \(toptenTravelTime!), wait time: \(toptenWaitTime!), total time: \(toptenTotalTime!)")
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                })
            }
        }
        
        catch {
            print("error, cannot access urgent care data")
            return
        }
    }

}
