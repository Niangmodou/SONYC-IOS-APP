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
import MapKitGoogleStyler
import DropDown

class MapView: UIViewController, FloatingPanelControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate,UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //9th Avenue and 34th Street latitude and longitude
    var userLocation = CLLocation()
    let locationManager = CLLocationManager()
    let startLatitude = 40.753365
    let startLongitude = -73.996367
    let address = CLGeocoder.init()
    
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
    
    var data: [String] = ["apple","appear","Azhar","code","BCom"]
    var dataFiltered: [String] = []
    var dropButton = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //deleteAllData()
        overrideUserInterfaceStyle = .light
        setUpSearchBar()
        getData()
        buildingButton.isHidden = true
        streetButton.isHidden = true
        reportButton.isHidden = true
        historyButton.isHidden = true
        tableView.isHidden = true
        
//        userLocation = locationManager.location
        
        self.setMapview()
        
        configureTileOverlay()
        
        //for the slide up panel 
        let slidingUp = FloatingPanelController()
        slidingUp.delegate = self
        
        let reportSlide = FloatingPanelController()
        reportSlide.delegate = self
        
        mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        self.locationManager.requestAlwaysAuthorization()

            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()

            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }

            mapView.delegate = self
            mapView.mapType = .standard
            mapView.isZoomEnabled = true
            mapView.isScrollEnabled = true

            if let coor = mapView.userLocation.location?.coordinate{
                mapView.setCenter(coor, animated: true)
            }
        
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
//        print(newTask.value(forKey: "reportAddress"), "mapview")
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        
        //the goBackButton is hidden
        //goBackButtonHidden(button: goBackButton)
        
        let location = CLLocationCoordinate2D(latitude: startLatitude, longitude: startLongitude)
        centerMapOnLocation(location, mapView: mapView)
        
        //Adding 34th Street and 9th Avenue annotation
//        let loc = MKPointAnnotation()
//
//        loc.coordinate = CLLocationCoordinate2D(latitude: startLatitude, longitude: startLongitude)
//        loc.title = "Current"
//
//
//
//        mapView.addAnnotation(loc)
        
        dataFiltered = data

            dropButton.anchorView = searchBar
            dropButton.bottomOffset = CGPoint(x: 0, y:(dropButton.anchorView?.plainView.bounds.height)!)
            dropButton.backgroundColor = .white
            dropButton.direction = .bottom

            dropButton.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)") //Selected item: code at index: 0
            }
        
    }
    
//    https://stackoverflow.com/questions/14580269/get-tapped-coordinates-with-iphone-mapkit (holding down mouse to drop pin in certain location) - setMapview, handleLongPress
    func setMapview(){
      let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapView.handleLongPress(gestureReconizer:)))
      lpgr.minimumPressDuration = 0.5
      lpgr.delaysTouchesBegan = true
      lpgr.delegate = self
      self.mapView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
        let touchLocation = gestureReconizer.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            
            
//            let annotations = self.mapView.annotations
//            self.mapView.removeAnnotations(annotations)
            
            //removing annotations when a new one is added
            self.mapView.removeAnnotations(mapView.annotations)
            
            plotAnnotation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            
            //replots the user location
//            let currentLoc = MKPointAnnotation()
//
//            currentLoc.coordinate = CLLocationCoordinate2D(latitude: startLatitude, longitude: startLongitude)
//            currentLoc.title = "Current"
//
//
//            mapView.addAnnotation(currentLoc)
            
            newTask.setValue(String(locationCoordinate.latitude), forKey: "reportLatitude")
            newTask.setValue(String(locationCoordinate.longitude), forKey: "reportLongitude")
            address.reverseGeocodeLocation(CLLocation.init(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)){ (places, error) in
                if error == nil{
                    
                    let pm = places! as [CLPlacemark]
                    if pm.count > 0 {
                        
                        let pm = places![0]
                        
                        print(pm.name ?? "none", " ")
                        print(pm.subLocality ?? "none", " ")
                        print(pm.locality ?? "none", " ")
                        print(pm.postalCode ?? "none", " ")
                        print(pm.country ?? "none", " ")
                        
//                        let address = String(pm.name ?? "Unknown number")  + " " + String(pm.subLocality ?? "Unknown number") + " " + " " + String(pm.locality ?? "Unknown number") + ", " + String(pm.postalCode ?? "Unknown number") + ", " + String(pm.country ?? "United States")
                        let address = String(pm.name ?? "Unknown number")  + " " + String(pm.subLocality ?? "Unknown number")
                        
                        let city = String(pm.locality ?? "Unknown number") + ", " + String(pm.postalCode ?? "Unknown number") + ", " + String(pm.country ?? "United States")
                        
                        newTask.setValue(String(address), forKey: "reportAddress")
                        newTask.setValue(String(city), forKey: "reportCity")
                        
      
                        
                        
                        self.tableView.isHidden = false
                        
                        self.tableView.reloadData()
                        
                    }
                    
//                    if let place = places{
//                        print(place)
//
//
//                    }
                }
            }

        return
      }
        if gestureReconizer.state != UIGestureRecognizer.State.began {
        return
      }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataFiltered = searchText.isEmpty ? data : data.filter({ (dat) -> Bool in
            dat.range(of: searchText, options: .caseInsensitive) != nil
        })

        dropButton.dataSource = dataFiltered
        dropButton.show()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        for ob: UIView in ((searchBar.subviews[0] )).subviews {
            if let z = ob as? UIButton {
                let btn: UIButton = z
                btn.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        dataFiltered = data
        dropButton.hide()
    }
    
    func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    //Function to process the search query when the search button has been clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        //print(searchBar.text)
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start{ (response,error) in
            //activityIndicator.stopAnimating()
            //UIApplication.shared.endIgnoringInteractionEvents()
            if response == nil {
                print("Error")
            }else{
                //let annotations = self.mapView.annotations
                //self.mapView.removeAnnotations(annotations)
                
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Creating Annotation and adding annotation to map
//                let annotation = MKPointAnnotation()
//                annotation.title = "Map Search"
//
//                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
//
//                self.mapView.addAnnotation(annotation)
                
                //Centering map on coordinate
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                
                self.centerMapOnLocation(coordinate, mapView: self.mapView)
                
            }
            
        }
    }
    
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
//        savingData()
//        let _ = navigationController?.popViewController(animated: true)
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
//            let title = each.value(forKey: "sonycType")
            
            //Creating and plotting the DOB annotation on the map
            plotAnnotation(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
        }
    }
    
    //Function to plot annotations on the map
    func plotAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
        let loc = MKPointAnnotation()
        
        loc.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        loc.title = title
        mapView.addAnnotation(loc)
        
    }
//    func plotAnnotation(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees){
//
//        let loc = MKPointAnnotation()
//
//        loc.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        loc.title = title
//
//        mapView.addAnnotation(loc)
//    }
    
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
    
    
    private func getData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "ReportIncident")
        
        do{
            //Loading data from CoreData
            allData = try context.fetch(fetch)
            
            
        }catch let error{
            print("Error: \(error)")
        }
    }
    
    //Function to get logo image based on type
    func getImage(reportType: String) -> UIImage {
        var image: UIImage!
        if reportType == "DOB" || reportType == "AHV" {
            image = UIImage(named: "dob.png")
        }
//        else if reportType == "311" {
//            image = UIImage(named: "Logo_311_non color.png")
//        }else if reportType == "DOT" {
//            image = UIImage(named: "Logo_Dot_not color.png")
//        }
        
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
    
    //Function to get current user's address based on lat and lon
    func getCurrentLocation() -> String {
        let center : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: startLatitude, longitude: startLongitude)
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        var addressString : String = ""
        
        let ceo: CLGeocoder = CLGeocoder()
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    
                }
        })
        
        return addressString
    }
    
    //Styling Mapview to look like Google Maps
    private func configureTileOverlay() {
        // We first need to have the path of the overlay configuration JSON
        guard let overlayFileURLString = Bundle.main.path(forResource: "overlay", ofType: "json") else {
                return
        }
        let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
        
        // After that, you can create the tile overlay using MapKitGoogleStyler
        guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
            return
        }
        
        // And finally add it to your MKMapView
        mapView.addOverlay(tileOverlay)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    
}

extension MapView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapCardCell", for: indexPath) as! MapCardCell
        
        
                var address: String!
                var city: String!
//                var startDate: String!
//                var endDate: String!
//                var incidentDate: String!
        
//                if api == "DOB" {
//                    let house = currentRow.value(forKey: "house_num") as! String
//                    let street = currentRow.value(forKey: "street") as! String
        print(newTask.value(forKey: "reportAddress"))
                
        
//                    address = "\(house) \(street)"
//        address = "\(String(describing: newTask.value(forKey: "reportAddress")))"
        address = newTask.value(forKey: "reportAddress") as? String ?? "none"

//            ?? "none"
        
        city = newTask.value(forKey: "reportCity") as? String ?? "none"
        

        
        let currLocation = getCurrentLocation()
        
        
//        if api == "311" {
            print("BENCHMARK 3 ---------------------")

            cell.configure(
                           address: address,
                           currLocation: currLocation,
                city: city
                        )
        
     
        
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
}

extension MapView: UITableViewDelegate{

    
}

//func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//    let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
//    if annotation.title == "Current"{
//        annotationView.glyphImage = UIImage(named: "Location_Original.png")
//    }
//    return annotationView
//}
func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
   {
       if !(annotation is MKPointAnnotation) {
           return nil
       }
       
       let annotationIdentifier = "AnnotationIdentifier"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
       
       if annotationView == nil {
           annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
           annotationView!.canShowCallout = true
       }
       else {
           annotationView!.annotation = annotation
       }
       
       let pinImage = UIImage(named: "Location_Original.png")
       annotationView!.image = pinImage

      return annotationView
   }
