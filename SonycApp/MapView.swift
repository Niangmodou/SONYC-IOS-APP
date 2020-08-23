//
//  MapView.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 7/23/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FloatingPanel
import CoreData

class MapView: UIViewController, FloatingPanelControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //9th Avenue and 34th Street latitude and longitude
    let startLatitude = 40.753365
    let startLongitude = -73.996367
    
    //Varaible to store retrieved data from CoreData
    var allData: [NSManagedObject] = []
    var currData: [NSManagedObject] = []
    
    @IBOutlet weak var searchTextBox: UISearchBar!
    //@IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var buildingButton: UIButton!
    @IBOutlet weak var streetButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    let manager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //deleteAllData()
        
        getData()
        
        //for the slide up panel 
        let slidingUp = FloatingPanelController()
        slidingUp.delegate = self
        
        let reportSlide = FloatingPanelController()
        reportSlide.delegate = self
        
        mapView.delegate = self
        
        //button styling
        curvingButton(button: historyButton)
        curvingButton(button: streetButton)
        curvingButton(button: reportButton)
        curvingButton(button: buildingButton)
        //curvingButtonRounder(button: goBackButton)
        
        //adding borders to buttons
        addingBorder(button: historyButton)
        addingBorder(button: reportButton)
        addingBorder(button: streetButton)
        addingBorder(button: buildingButton)
        
        //adding border color (white)
        addingBorderColorWhite(button: historyButton)
        addingBorderColorWhite(button: reportButton)
        addingBorderColorWhite(button: streetButton)
        addingBorderColorWhite(button: buildingButton)
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        
        //the goBackButton is hidden
        //goBackButtonHidden(button: goBackButton)
        
        let location = CLLocationCoordinate2D(latitude: startLatitude, longitude: startLongitude)
        centerMapOnLocation(location, mapView: mapView)
        
        //Adding 34th Street and 9th Avenue annotation
        let loc = MKPointAnnotation()
        
        loc.coordinate = CLLocationCoordinate2D(latitude: startLatitude, longitude: startLongitude)
        loc.title = "Current"
        
        mapView.addAnnotation(loc)
        
    }
    
    /*
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //finding the user's location
        self.manager.requestWhenInUseAuthorization()
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            self.manager.delegate = self
            self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.manager.startUpdatingLocation()
        }
    }
    */
    
    //if the buttons/clips are pressed
    @IBAction func buttonPressed(button: UIButton){
        
        button.isSelected.toggle()
        
        button.layer.borderColor = UIColor.white.cgColor
        if button.isSelected{
            button.layer.borderColor = UIColor.faceSelected().cgColor
        }
        if button == reportButton{
            button.setImage(UIImage(named: "Logo_311.png"), for: [.highlighted, .selected])
            
        }
        if button == streetButton{
            button.setImage(UIImage(named: "Logo_Dot.png"), for: [.highlighted, .selected])
        }
        if button == historyButton{
            button.setImage(UIImage(named: "Icon_History.png"), for: [.highlighted, .selected] )
        }
        if button == buildingButton{
            button.setImage(UIImage(named: "Icon_History.png"), for: [.highlighted, .selected] )
        }
        //stores which button was selected when the report was made
        newTask.setValue(button.title(for: .normal), forKey: "locationType")
        //saving the data stored
        savingData()
        let _ = navigationController?.popViewController(animated: true)
    }
    
    //makes the back button hidden
    /*
    @IBAction func goBackButtonHidden(button: UIButton) {
        button.isHidden = true
    }
 */
    
    //makes the textbox hidden
    @IBAction func textBoxHidden(textbox: UITextField) {
        textbox.isHidden = true
    }
               
    //Function to plot annotations onto Map
    func plotAnnotations(data: [NSManagedObject]) {
        
        for each in data {
            let latitude = each.value(forKey: "latitude")
            let longitude = each.value(forKey: "longitude")
            let title = each.value(forKey: "sonycType")

            //Creating and plotting the DOB annotation on the map
            plotAnnotation(title: title as! String, latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
        }
    }
    
    //Function to plot annotations on the map
    func plotAnnotation(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
        let loc = MKPointAnnotation()
        
        loc.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        loc.title = title
        
        mapView.addAnnotation(loc)
    }
    
    //Function to center map on New York City
    func centerMapOnLocation(_ location: CLLocationCoordinate2D, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 5000
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: regionRadius * 0.0625, longitudinalMeters: regionRadius * 0.0625)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func deleteAllData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ReportIncident")
        fetchRequest.returnsObjectsAsFaults = false

        do{
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results{
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error {
            print("Error: \(error) :(")
        }
    }
    
    //Fucntion to add image to an annotation
       func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           print("hi")
           var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
           
           if annotationView == nil {
               annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
           }
           
           if annotation.title == "311 pin" {
               annotationView?.image = UIImage(named: "Pin_311_non-color.png")
           }else if annotation.title == "DOB" || annotation.title == "AHV" {
               print("hi")
               annotationView?.image = UIImage(named: "Pin_dob_non-color.png")
           }else if annotation.title == "Current"{
               print("hi")
               annotationView?.image = UIImage(named: "Location_Original.png")
           }/*else {
               annotationView?.image = UIImage(named: "Pin_History_non-color.png")
           }
            */
           
           return annotationView
       }
    
    private func getData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "ReportIncident")
        
        do{
            //Loading data from CoreData
            allData = try context.fetch(fetch)
            
            //Plot Annotations on the Map
            plotAnnotations(data: allData)
            
            //Sort Data array
            /*
            allData.sort(by: {
                guard let first: Float = ($0.value(forKey: "distance") as! Float) else {}
                guard let second: Float = ($1.value(forKey: "distance") as! Float) else {}
                
                return first < second
                
            })
            */
            
        }catch let error{
            print("Error: \(error)")
        }
    }

    //Function to get logo image based on type
    func getImage(reportType: String) -> UIImage {
        var image: UIImage!
        if reportType == "DOB" || reportType == "AHV" {
            image = UIImage(named: "dob.png")
        }else if reportType == "311" {
            image = UIImage(named: "Logo_311_non color.png")
        }else if reportType == "DOT" {
            image = UIImage(named: "Logo_Dot_not color.png")
        }
        
        return image
    }
    
    //Function to get api name based on type
    func getType(api: String) -> String {
        var text: String!
        
        if api == "DOB" {
            text = "Building Construction Permit"
        }else if api == "DOT" {
            text = "Street Construction Permit"
        }else if api == "311" {
            text = "311 Noise Report"
        }else if api == "AHV" {
            text = "After Hour Variances"
        }
        
        return text
    }
    
    func filterData() {
        /*
         
         */
    }
    
}

extension MapView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapCardCell", for: indexPath) as! MapCardCell
        
        //Get the contents of the current row
        let currentRow = allData[indexPath.row]
        
        //Parsing information from currentRow
        let api = currentRow.value(forKey: "sonycType") as! String
        let type = getType(api: api)
        
        //Location Data
        let id = currentRow.value(forKey: "unique_id") as! String
        
        var address: String!
        var startDate: String!
        var endDate: String!
        var incidentDate: String!
        
        if api == "DOB" {
            let house = currentRow.value(forKey: "house_num") as! String
            let street = currentRow.value(forKey: "street") as! String
        
            address = "\(house) \(street)"
            
            startDate = (currentRow.value(forKey: "startDate") as! String)
            endDate = (currentRow.value(forKey: "endDate") as! String)
        }else if api == "AHV"  {
            address = (currentRow.value(forKey: "street") as! String)
            startDate = (currentRow.value(forKey: "startDate") as! String)
            endDate = (currentRow.value(forKey: "endDate") as! String)
        }else if api == "311" {
            address = (currentRow.value(forKey: "street") as! String)
            
            incidentDate = (currentRow.value(forKey: "created_date") as! String)
        }
        
        let borough = currentRow.value(forKey: "borough") as! String
        let zipcode = currentRow.value(forKey: "zipcode") as! String
        
        //Getting the logo image based on which type of recording
        let image = getImage(reportType: api)
        
        let distance = currentRow.value(forKey: "distance") as! String
        
        let location = "\(borough),NY \(zipcode)"
   
    
        if api == "311" {
            print("BENCHMARK 3 ---------------------")
            cell.configure(id: id,
                           apiType: type,
                           logo: image,
                           distance: distance,
                           address: address,
                           location: location,
                           incidentDate: incidentDate)
        }else {
            cell.configure(id: id,
                           apiType: type,
                           logo: image,
                           distance: distance,
                           address: address,
                           location: location,
                           start: startDate,
                           end: endDate)
        }
        
        return cell
    }
}

extension MapView: UITableViewDelegate{
    //Displaying a tapped location on the map
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Get the contents of the current row
        let currentRow = allData[indexPath.row]
        
        //Extracting lat and lon
        let latitude = currentRow.value(forKey: "latitude") as! CLLocationDegrees
        let longitude = currentRow.value(forKey: "longitude") as! CLLocationDegrees
        print(latitude, longitude)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
       
        //Focusing map on that location
        centerMapOnLocation(location, mapView: mapView)

    }
    
}
