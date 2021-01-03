//
//  ButtonInformation.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 9/21/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//

import Foundation
import UIKit
import MapKit

func buttonXPosition(button: UIButton) -> CGFloat{
    let xPos = button.frame.origin.x + button.frame.width
    return xPos
}

func buttonYPosition(button: UIButton) -> CGFloat{
    let yPos = button.frame.origin.y + button.frame.height
    return yPos
}

func labelXPosition(label: UILabel) -> CGFloat{
    let xPos = label.frame.origin.x + label.frame.width
    return xPos
}

func labelYPosition(label: UILabel) -> CGFloat{
    let yPos = label.frame.origin.y + label.frame.height
    return yPos
}

func mapViewXPosition(map: MKMapView) -> CGFloat{
    let xPos = map.frame.origin.x + map.frame.width
    return xPos
}

func mapViewYPosition(map: MKMapView) -> CGFloat{
    let yPos = map.frame.origin.y + map.frame.height
    return yPos
}

func imageViewXPosition(image: UIImageView) -> CGFloat{
    let xPos = image.frame.origin.x + image.frame.width
    return xPos
}

func imageViewYPosition(image: UIImageView) -> CGFloat{
    let yPos = image.frame.origin.y + image.frame.height
    return yPos
}


