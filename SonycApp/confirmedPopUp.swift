//
//  confirmedPopUp.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 8/2/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//

import Foundation
import UIKit
class confirmedPopUp: UIViewController{
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var okButton: UIButton!
    override func viewDidLoad() {
        //button styling to curve the button's borders
        curvingButton(button: okButton)
        popUpView.layer.masksToBounds = true
    }
    
      //dimissing the popup
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
