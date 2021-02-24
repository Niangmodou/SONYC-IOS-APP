//
//  MapCardCell.swift
//  SonycApp
//
//  Created by Modou Niang on 8/20/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class MapCardCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var logoImage: UIImageView!
//    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
//    @IBOutlet weak var locationLabel: UILabel!
//    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var apiLabel: UILabel!
//    @IBOutlet weak var permitLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    //Varaibles to store report incident for the card
//    var api: String!
    var userLocation: String!
    var reportLocation: String!
    var cityLocation: String!
//    var reportLatitude: String!
//    var reportLongitude: String!
    
    
    @IBAction func confirm(_ sender: Any) {
        
        print("Confirm Clicked")
        
        //Updating CoreData associated with the current Report
//        newTask.setValue(api, forKey: "api")
        print(newTask.value(forKey: "reportAddress"))
        print(newTask.value(forKey: "reportLatitude"))
        print(newTask.value(forKey: "reportLongitude"))
//        newTask.setValue(reportLocation, forKey: "reportAddress")
//        newTask.setValue(reportLatitude, forKey: "reportLatitude")
//        newTask.setValue(reportLongitude, forKey: "reportLongitude")
        
        savingData()
    }
    
    
    func configure(
                   address: String,
                   currLocation: String,
        city: String
                   ) {
        
        //Setting labels to update each report
//        api = apiType
        userLocation = currLocation
        reportLocation = String(address)
        cityLocation = String(city)
//        reportLatitude = String(latitude)
//        reportLongitude = String(longitude)
        
        //Setting labels to update each report
        addressLabel.text = String(address)
        apiLabel.text = String(city)

        logoImage.image = wordsToImage[newTask.value(forKey: "noiseType") as? String ?? "other"]
        //Fitting text to label
//        idLabel.sizeToFit()
        apiLabel.sizeToFit()
//        distanceLabel.sizeToFit()
        addressLabel.sizeToFit()
//        locationLabel.sizeToFit()
//        permitLabel.sizeToFit()
        
        //Styling the card
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 5.0
        
        confirmButton.layer.cornerRadius = 15.0
    }
    
}
