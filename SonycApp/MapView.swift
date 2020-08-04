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

class MapView: UIViewController, FloatingPanelControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var searchTextBox: UITextField!
    
    
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var buildingButton: UIButton!
    @IBOutlet weak var streetButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    
    
    
    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for the slide up panel 
        let slidingUp = FloatingPanelController()
        slidingUp.delegate = self
        mapView.delegate = self
        
        //button styling
        curvingButton(button: historyButton)
        curvingButton(button: streetButton)
        curvingButton(button: reportButton)
        curvingButton(button: buildingButton)
        curvingButtonRounder(button: goBackButton)
        
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
        
        
        
        //the goBackButton is hidden
        goBackButtonHidden(button: goBackButton)
        
        guard let contentVC = storyboard?.instantiateViewController(identifier: "slideUp") as? SlideUpView
            else{
                return
        }
        
        slidingUp.set(contentViewController: contentVC)
        slidingUp.addPanel(toParent: self)
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //finding the user's location
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
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
            button.setImage(UIImage(named: "Logo_311"), for: [.highlighted, .selected])
        }
        if button == streetButton{
            button.setImage(UIImage(named: "Logo_Dot"), for: [.highlighted, .selected])
        }
        if button == historyButton{
            button.setImage(UIImage(named: "Icon_History"), for: [.highlighted, .selected] )
        }
        
        
    }
    
    //makes the back button hidden
    @IBAction func goBackButtonHidden(button: UIButton) {
        button.isHidden = true
    }
    
    //makes the textbox hidden
    @IBAction func textBoxHidden(textbox: UITextField) {
        textbox.isHidden = true
    }
    
    
    
}
