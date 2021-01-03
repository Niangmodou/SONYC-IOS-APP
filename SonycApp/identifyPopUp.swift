//
//  identifyPopUp.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 8/2/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//

import Foundation
import UIKit

class identifyPopUp: UIViewController{
    @IBOutlet weak var gotItButton: UIButton!
    
    @IBOutlet weak var popUpView: UIView!
    override func viewDidLoad() {
        //button styling, curving button borders
        curvingButton(button: gotItButton)
        popUpView.layer.masksToBounds = true
    }
    
    //dimissing the popup
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
