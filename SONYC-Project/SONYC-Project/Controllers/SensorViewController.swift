//
//  SensorViewController.swift
//  SONYC-Project
//
//  Created by Modou Niang on 7/2/20.
//  Copyright © 2020 modouniang. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import SwiftCSV

class SensorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        addSensor()
        
        addHamburgerIcon()
        
    }
    
    //Adding the Sensor Button
    func addSensor(){
        let image = UIImage(named: "logo.png") as UIImage?
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.frame = CGRect(x: 72, y: 233, width: 230, height: 230)
        //button.center = view.center
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(self.beginRecording(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    //Addding the button to redirect to the maps page
    func addHamburgerIcon(){
        let image = UIImage(named: "Hamburger.png") as UIImage?
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.frame = CGRect(x: 18, y: 57, width: 26, height: 18)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(self.navigateMap(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    //Function for sensor button to begin recording
    @objc func beginRecording(sender: UIButton){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        //Getting and presenting recording view controller
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "soundLevel")
        nextViewController.modalPresentationStyle = .fullScreen
        UIView.setAnimationsEnabled(false)
        performSegue(withIdentifier: "recordingPipeline", sender: self)
        UIView.setAnimationsEnabled(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! RecordViewController
        
        destination.startRecording()
    }
    
    //Function for hamburger button to naviage to map
    @objc func navigateMap(sender: UIButton){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        //Getting and presenting map view controller
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "map")
        self.present(nextViewController, animated: false, completion: nil)
    }
    
    //Function to get a users current location and distance
    func getDistance(reportLocation: CLLocation) -> String {
        //Latitude and Longitude of 34th street and 9th ave
        let currLat = 40.753365
        let currLon = -73.996367
        
        let currLocation = CLLocation(latitude: currLat, longitude: currLon)
        
        let distanceMeters = currLocation.distance(from: reportLocation)
        
        let distanceMiles = distanceMeters/1609.344
        
        return String(distanceMiles)
    }
    
    //Functions to fetch data from the APIS and save them to CoreData
    func loadData(){
        getAHVData()
        getDOBPermitData()
        //get311Data()
    }
    
    func get311Data(){
        print("311")
        let url = URL(string:"https://data.cityofnewyork.us/resource/erm2-nwe9.json")
        let task = URLSession.shared.dataTask(with: url!){ (data,response,error) in
            //Making a call to the API and retrieving the data response
            guard let dataResponse = data, error == nil else{
                print(error?.localizedDescription ?? "Response Error")
                return
            }
           print(dataResponse)
            //Retrieving the json data from the data response returned from the server
            do{
                print("hi 311")
                 let jsonResult = try JSONSerialization.jsonObject(with: dataResponse, options: []) as? [Dictionary<String, AnyObject>]
                               
                let apiType = "311"
                print("BENCHMARK 0 ---------------------")
                self.saveToCoreData(jsonResponse: jsonResult as Any, api: apiType)
            }catch let parsingError{
                print("Error:", parsingError)
            }
        }
        task.resume()
    }
    
    func getDOBPermitData(){
        let url = URL(string: "https://data.cityofnewyork.us/resource/ipu4-2q9a.json?zip_code=10001")
    
        let task = URLSession.shared.dataTask(with: url!){ (data,response,error) in
            //Making a call to the API and retrieving the data response
            guard let dataResponse = data, error == nil else{
                print(error?.localizedDescription ?? "Response Error")
                return
            }
            do{
                let jsonResult = try JSONSerialization.jsonObject(with: dataResponse, options: []) as? [Dictionary<String, AnyObject>]
                
                //print(jsonResult as Any)
                self.saveToCoreData(jsonResponse: jsonResult as Any, api: "DOB")
                
                
            }catch let parsingError{
                print("Error:", parsingError)
            }
            
        }
        task.resume()
    }
    
    func getZipcode(location: CLLocation) -> String {
        let geocoder: CLGeocoder = CLGeocoder()
        var zipcode: String!
        /*
        geocoder.reverseGeocodeLocation(location) {(placemarks, error) in
            if error != nil {
                print("Reverse Geocode Fail: \(error!.localizedDescription)")
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            print( placemark.postalCode as Any)
            zipcode = placemark.postalCode
        }
         */
        
        return "10001"
    }
    
    func getAHVData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        if let url = URL(string: "https://raw.githubusercontent.com/NYCDOB/ActiveAHVs/gh-pages/data/activeAHVs.csv") {
            do{
                let contents = try String(contentsOf: url)
                
                let csv: CSV = try CSV(string: contents)
                
                try csv.enumerateAsDict { dict in
                    let api = "AHV"
                    let bin = dict["BIN"]
                    let startDate = dict["Start Date"]
                    let endDate = dict["End Date"]
                    
                    //Location Data
                    let address = dict["Address"]
                    let borough = dict["Borough"]
                    
                    let latitude = (dict["Lat"]! as NSString).doubleValue
                    let longitude = (dict["Lon"]! as NSString).doubleValue
                    
                    let reportLoc = CLLocation(latitude: latitude,
                                               longitude: longitude)
                    
                    let zipcode = self.getZipcode(location: reportLoc)
                    
        
                    let distance = Double(self.getDistance(reportLocation: reportLoc))
                    let roundedDistance = Double(round(100*distance!)/100)
                    let roundedDistanceString = String(roundedDistance)
                    
                    //Save to CoreData
                    let context = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "ReportIncident", in: context)
                    
                    let newEntity = NSManagedObject(entity: entity!,
                                                    insertInto: context)
                    newEntity.setValue(api, forKey: "sonycType")
                    newEntity.setValue(bin, forKey: "unique_id")
                    newEntity.setValue(latitude, forKey: "latitude")
                    newEntity.setValue(longitude, forKey: "longitude")
                    newEntity.setValue(address, forKey: "street")
                    newEntity.setValue(borough, forKey: "borough")
                    newEntity.setValue(zipcode, forKey: "zipcode")
                    newEntity.setValue(roundedDistanceString, forKey: "distance")
                    newEntity.setValue(startDate, forKey: "startDate")
                    newEntity.setValue(endDate, forKey: "endDate")
                    
                }
            }catch{
                
            }
        }
        
    }
    
    func saveToCoreData(jsonResponse: Any, api: String){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "ReportIncident",
                                                    in: context)
            
            if api == "DOB" {
                for item in jsonResponse as! [Dictionary<String, AnyObject>] {
                    //print(item)
                    if let longitude = (item["gis_longitude"] as? NSString)?.doubleValue {
                        if let latitude = (item["gis_latitude"] as? NSString)?.doubleValue {
                            
                            //Job Data
                            let id = (item["bin__"]) as! String
                            let job_type = item["job_type"] as! String
                            
                            //Location Data
                            let house = item["house__"]
                            let borough = item["borough"]
                            let street = item["street_name"]
                            let zipcode = item["zip_code"]
                            
                            //Date Information
                            let startDate = item["job_start_date"]
                            let endDate = item["expiration_date"]
                            
                            //Distance Location
                            let reportLoc = CLLocation(latitude: latitude, longitude: longitude)
                            
                            let distance = Double(self.getDistance(reportLocation: reportLoc))
                            //let x = Double(distance)
                            let roundedDistance = Double(round(100*distance!)/100)
                            //print(y)
                            let roundedDistanceString = String(roundedDistance)
                            
                    
                            let newEntity = NSManagedObject(entity: entity!,
                                                            insertInto: context)
                            
                            newEntity.setValue(job_type, forKey: "job_type")
                            newEntity.setValue(id, forKey: "unique_id")
                            newEntity.setValue(api, forKey: "sonycType")
                                
                            //Stores location data
                            newEntity.setValue(house, forKey: "house_num")
                            newEntity.setValue(latitude, forKey: "latitude")
                            newEntity.setValue(longitude, forKey: "longitude")
                            newEntity.setValue(borough, forKey: "borough")
                            newEntity.setValue(street, forKey: "street")
                            newEntity.setValue(roundedDistanceString, forKey: "distance")
                            newEntity.setValue(zipcode, forKey: "zipcode")
                            
                            //Storing Date information
                            newEntity.setValue(startDate, forKey: "startDate")
                            newEntity.setValue(endDate, forKey: "endDate")
                        
                            
                        }else{
                            print("error")
                        }
                    }
                }
            }else if api == "311" {
                for item in jsonResponse as! [Dictionary<String, AnyObject>] {
                    if let longitude = (item["longitude"] as? NSString)?.doubleValue {
                        if let latitude = (item["latitude"] as? NSString)?.doubleValue {
                            
                            let id = item["unique_key"] as! String
                            
                            let incidentDate = item["created_date"] as! String
                            print(incidentDate)
                            
                            let borough = item["city"] as! String
                            let zipcode = item["incident_zip"] as! String
                            
                            let addressType = item["address_type"] as! String
                            
                            var address: String!
                            do{
                                address = try item["incident_address"] as! String
                            }catch{
                                let street1 = item["intersection_street_1"]
                                let street2 = item["intersection_street_2"]
                                
                                address = "\(street1) and \(street2)"
                            }
                            
                            //Getting distance information
                            //Distance Location
                            let reportLoc = CLLocation(latitude: latitude, longitude: longitude)
                            
                            let distance = Double(self.getDistance(reportLocation: reportLoc))
                            //let x = Double(distance)
                            let roundedDistance = Double(round(100*distance!)/100)
                            //print(y)
                            let roundedDistanceString = String(roundedDistance)
                            print("BENCHMARK 1 ---------------------")
                            //Storing incident information
                            let newEntity = NSManagedObject(entity: entity!,
                                                            insertInto: context)
                            
                            newEntity.setValue(id, forKey: "unique_id")
                            newEntity.setValue(api, forKey: "sonycType")
                            newEntity.setValue(latitude, forKey: "latitude")
                            newEntity.setValue(longitude, forKey: "longitude")
                            newEntity.setValue(roundedDistanceString, forKey: "distance")
                            newEntity.setValue(borough, forKey: "borough")
                            newEntity.setValue(zipcode, forKey: "zipcode")
                            newEntity.setValue(address, forKey: "street")
                            newEntity.setValue(incidentDate, forKey: "incidentDate")
                            
                            print("BENCHMARK 2 ---------------------")
                            
                        }
                    }
                }
            }
            
        }
        
    }
}

