//
//  TableCell.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 8/9/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//

import Foundation
import UIKit

//will be responsible for styling the cells that will hold the details of the recordings
//will display the location and time of the recording
//will also display the image of the type of report
//will also display the avg decibels for the whole recording
class TableCell: UITableViewCell{
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var imageCard: UIImageView!
    @IBOutlet weak var avgDecibels: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
}
