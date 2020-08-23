//
//  selectLocationPopUp.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 8/2/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//

import Foundation
import UIKit

class selectLocationPopUp: UIViewController{
    
    @IBOutlet weak var popUpView: UIView!
    
    override func viewDidLoad() {
        popUpView.layer.masksToBounds = true
    }
}
