//
//  ButtonStyling.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 7/23/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//

import Foundation
import UIKit

func addingBorder(button: UIButton){
    button.layer.borderWidth = 2;
}

func addingBorderColorBlack(button: UIButton){
    button.layer.borderColor = UIColor.black.cgColor
}

func addingBorderColorWhite(button: UIButton){
    button.layer.borderColor = UIColor.white.cgColor
}

func curvingButton(button: UIButton){
    button.layer.cornerRadius = 10;
}

func curvingButtonRounder(button: UIButton){
    button.layer.cornerRadius = 20;
}

extension UIView{
    func roundCorners(cornerRadius: Double){
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
