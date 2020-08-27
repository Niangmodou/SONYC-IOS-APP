//
//  ReportsTableView.swift
//  SonycApp
//
//  Created by Modou Niang on 8/19/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//
//
//import Foundation
//import UIKit
//import CoreData
//import CoreLocation
//
//class ReportsTableView: UIViewController, UITableViewDelegate {
//
//    //Varaible to store retrieved data from CoreData
//    var allData: [NSManagedObject] = []
//    var currData: [NSManagedObject] = []
//
//
//
//
//    override func viewDidLoad() {
//        /*
//        deleteAllData()
//
//        //Loading and storing data from CoreData
//        getData()
//
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        self.tableView.allowsSelection = true
//         */
//
//    }
//
//    private func deleteAllData(){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recording")
//        fetchRequest.returnsObjectsAsFaults = false
//
//        do{
//            let results = try managedContext.fetch(fetchRequest)
//            for managedObject in results{
//                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
//                managedContext.delete(managedObjectData)
//            }
//        } catch let error {
//            print("Error: \(error) :(")
//        }
//    }
//
//    private func getData(){
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
//            return
//        }
//
//        let context = appDelegate.persistentContainer.viewContext
//        let fetch = NSFetchRequest<NSManagedObject>(entityName: "ReportIncident")
//
//        do{
//            //Loading data from CoreData
//            allData = try context.fetch(fetch)
//
//            let mapController: MapView = (storyboard?.instantiateViewController(identifier: "map"))! as MapView
//            //Plot annotations onto Map
//            mapController.plotAnnotations(data: allData)
//
//            //Sort Data array
//            /*
//            allData.sort(by: {
//                guard let first: Float = ($0.value(forKey: "distance") as! Float) else {}
//                guard let second: Float = ($1.value(forKey: "distance") as! Float) else {}
//
//                return first < second
//
//            })
//            */
//
//        }catch let error{
//            print("Error: \(error)")
//        }
//    }
//
//    //Function to get logo image based on type
//    func getImage(reportType: String) -> UIImage {
//        var image: UIImage!
//        if reportType == "DOB" || reportType == "AHV" {
//            image = UIImage(named: "dob.png")
//        }else if reportType == "311" {
//            image = UIImage(named: "Logo_311_non color.png")
//        }else if reportType == "DOT" {
//            image = UIImage(named: "Logo_Dot_not color.png")
//        }
//
//        return image
//    }
//
//    //Function to get api name based on type
//    func getType(api: String) -> String {
//        var text: String!
//
//        if api == "DOB" {
//            text = "Building Construction Permit"
//        }else if api == "DOT" {
//            text = "Street Construction Permit"
//        }else if api == "311" {
//            text = "311 Noise Report"
//        }else if api == "AHV" {
//            text = "After Hour Variances"
//        }
//
//        return text
//    }
//
//    func filterData() {
//        /*
//
//         */
//    }
//
//}
//
//extension ReportsTableView : UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         return currData.count
//     }
//
//     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//         let cell = tableView.dequeueReusableCell(withIdentifier: "mapCardCell", for: indexPath) as! MapCardCell
//
//         //Get the contents of the current row
//         let currentRow = allData[indexPath.row]
//
//         //Parsing information from currentRow
//         let api = currentRow.value(forKey: "sonycType") as! String
//         let type = getType(api: api)
//
//         //Location Data
//         let id = currentRow.value(forKey: "unique_id") as! String
//
//         var address: String!
//         var startDate: String!
//         var endDate: String!
//         var incidentDate: String!
//
//         if api == "DOB" {
//             let house = currentRow.value(forKey: "house_num") as! String
//             let street = currentRow.value(forKey: "street") as! String
//
//             address = "\(house) \(street)"
//
//             startDate = (currentRow.value(forKey: "startDate") as! String)
//             endDate = (currentRow.value(forKey: "endDate") as! String)
//         }else if api == "AHV"  {
//             address = (currentRow.value(forKey: "street") as! String)
//             startDate = (currentRow.value(forKey: "startDate") as! String)
//             endDate = (currentRow.value(forKey: "endDate") as! String)
//         }else if api == "311" {
//             address = (currentRow.value(forKey: "street") as! String)
//
//             incidentDate = (currentRow.value(forKey: "created_date") as! String)
//         }
//
//         let borough = currentRow.value(forKey: "borough") as! String
//         let zipcode = currentRow.value(forKey: "zipcode") as! String
//
//         //Getting the logo image based on which type of recording
//         let image = getImage(reportType: api)
//
//         let distance = currentRow.value(forKey: "distance") as! String
//
//         let location = "\(borough),NY \(zipcode)"
//
//
//         if api == "311" {
//             print("BENCHMARK 3 ---------------------")
//             cell.configure(id: id,
//                            apiType: type,
//                            logo: image,
//                            distance: distance,
//                            address: address,
//                            location: location,
//                            incidentDate: incidentDate)
//         }else {
//             cell.configure(id: id,
//                            apiType: type,
//                            logo: image,
//                            distance: distance,
//                            address: address,
//                            location: location,
//                            start: startDate,
//                            end: endDate)
//         }
//
//         return cell
//     }
//    /*
//    //Function to center map on New York City
//    func centerMapOnLocation(_ location: CLLocationCoordinate2D, mapView: MKMapView) {
//        let regionRadius: CLLocationDistance = 5000
//        let coordinateRegion = MKCoordinateRegion(center: location,
//                                                  latitudinalMeters: regionRadius * 0.0625, longitudinalMeters: regionRadius * 0.0625)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }
//    */
//}
//
///*
//extension ReportsTableView : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //Get the contents of the current row
//        let currentRow = myData[indexPath.row]
//
//        //Extracting lat and lon
//        let latitude = currentRow.value(forKey: "latitude") as! CLLocationDegrees
//        let longitude = currentRow.value(forKey: "longitude") as! CLLocationDegrees
//        print(latitude, longitude)
//        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//
//        //Focusing map on that location
//        centerMapOnLocation(location, mapView: mapView)
//
//    }
//}
// */
