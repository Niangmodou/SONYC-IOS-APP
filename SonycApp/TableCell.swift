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
    
    @IBOutlet weak var average: UILabel!
    @IBOutlet weak var averageDecibels: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let pictureSize = picture.sizeThatFits(contentView.frame.size)
        let picSize = pictureSize
        picture.frame = CGRect(x: 30, y: (contentView.frame.size.height - picSize.height)/3, width: picSize.width, height: contentView.frame.height/2)
        let pictureX = picture.frame.origin.x + picture.frame.width
        location.frame = CGRect(x: pictureX + 30, y: (contentView.frame.size.height - picSize.height)/8, width: contentView.frame.width - 125, height: contentView.frame.height/2.5)
//        location.sizeToFit()
        let locationY = location.frame.origin.y + location.frame.height
        let locationX = location.frame.origin.x + location.frame.width
        average.frame = CGRect(x: locationX - 45, y: location.frame.origin.y, width: contentView.frame.width/10, height: contentView.frame.height/2.5)
//        average.sizeToFit()
        date.frame = CGRect(x: location.frame.origin.x, y: locationY, width: contentView.frame.width/5.5, height: contentView.frame.height/2.5)
        let dateX = date.frame.origin.x + date.frame.width
        time.frame = CGRect(x: dateX, y: locationY, width: screenWidth/5.5 , height: 40)
        averageDecibels.frame = CGRect(x: average.frame.origin.x - contentView.frame.width/40, y: date.frame.origin.y, width: screenWidth/5, height: contentView.frame.height/2.5)
//        averageDecibels.sizeToFit()
//        location.sizeToFit()
    }
}
