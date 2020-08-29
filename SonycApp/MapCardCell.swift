//
//  MapCardCell.swift
//  SonycApp
//
//  Created by Modou Niang on 8/20/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//

import Foundation
import UIKit

class MapCardCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var apiLabel: UILabel!
    @IBOutlet weak var permitLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    //Varaibles to store report incident for the card
    var api: String!
    var userLocation: String!
    var reportLocation: String!
    var reportLatitude: String!
    var reportLongitude: String!
    
    @IBAction func confirm(_ sender: Any) {
        
        print("Confirm Clicked")
        
        //Updating CoreData associated with the current Report
        newTask.setValue(api, forKey: "api")
        newTask.setValue(reportLocation, forKey: "reportAddress")
        newTask.setValue(reportLatitude, forKey: "reportLatitude")
        newTask.setValue(reportLongitude, forKey: "reportLongitude")
        
        savingData()
        
        
    }
    
    /*
     @IBAction func confirm(_ sender: Any) {
     print("Confirm Clicked")
     print(api)
     print(reportLocation)
     print(reportLatitude)
     print(reportLongitude)
     //Updating CoreData associated with the current Report
     newTask.setValue(api, forKey: "api")
     newTask.setValue(reportLocation, forKey: "reportAddress")
     newTask.setValue(reportLatitude, forKey: "reportLatitude")
     newTask.setValue(reportLongitude, forKey: "reportLongitude")
     
     savingData()
     
     }\*/
    
    
    func configure(id: String,
                   apiType: String,
                   logo: UIImage,
                   distance: String,
                   address: String,
                   location: String,
                   start: String = "0",
                   end: String = "0",
                   incidentDate: String = "0",
                   currLocation: String,
                   latitude: Float,
                   longitude: Float) {
        
        //Setting labels to update each report
        api = apiType
        userLocation = currLocation
        reportLocation = address
        reportLatitude = String(latitude)
        reportLongitude = String(longitude)
        
        //Setting labels to update each report
        idLabel.text = id
        logoImage.image = logo
        distanceLabel.text = "\(distance) mi"
        addressLabel.text = address
        locationLabel.text = location
        apiLabel.text = api
        
        if incidentDate != "0"{
            permitLabel.text = "Incident Date: \(incidentDate)"
        }else{
            permitLabel.text = "Permit: \(start) to \(end)"
        }
        
        //Fitting text to label
        idLabel.sizeToFit()
        apiLabel.sizeToFit()
        distanceLabel.sizeToFit()
        addressLabel.sizeToFit()
        locationLabel.sizeToFit()
        permitLabel.sizeToFit()
        
        //Styling the card
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 5.0
        
        confirmButton.layer.cornerRadius = 15.0
    }
}
