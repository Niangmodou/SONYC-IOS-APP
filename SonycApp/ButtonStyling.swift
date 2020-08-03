//
//  ButtonStyling.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 7/23/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//

import Foundation
import UIKit

//adds border to button
func addingBorder(button: UIButton){
    button.layer.borderWidth = 2;
}

//adds border color (black)
func addingBorderColorBlack(button: UIButton){
    button.layer.borderColor = UIColor.black.cgColor
}

//adds border color (white)
func addingBorderColorWhite(button: UIButton){
    button.layer.borderColor = UIColor.white.cgColor
}

//button styling (curves edges)
func curvingButton(button: UIButton){
    button.layer.cornerRadius = 10;
}

//button styling (curves edges with a bigger radius)
func curvingButtonRounder(button: UIButton){
    button.layer.cornerRadius = 20;
}

extension UIView{
    //rounds the corners of the UIView
    func roundCorners(cornerRadius: Double){
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
