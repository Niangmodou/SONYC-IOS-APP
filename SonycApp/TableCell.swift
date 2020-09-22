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
    static let identifier = "TableCell"
    
    static let picture: UIImageView = {
        let picture = UIImageView()
        picture.image = wordsToImage[" Music"]
        picture.contentMode = .scaleAspectFill
        return picture
    }()
    static let location: UILabel = {
        let location = UILabel()
        location.text = "Location"
        return location
    }()
    static let date: UILabel = {
        let date = UILabel()
        date.text = "date"
        return date
    }()
    static let time: UILabel = {
        let time = UILabel()
        time.text = "time"
        return time
    }()
    
    static let average: UILabel = {
          let average = UILabel()
          average.text = "Avg"
          return average
      }()
    static let averageDecibels: UILabel = {
           let averageDecibels = UILabel()
           averageDecibels.text = "0 db"
           return averageDecibels
       }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(TableCell.picture)
        contentView.addSubview(TableCell.location)
        contentView.addSubview(TableCell.date)
        contentView.addSubview(TableCell.time)
        contentView.addSubview(TableCell.average)
        contentView.addSubview(TableCell.averageDecibels)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let pictureSize = TableCell.picture.sizeThatFits(contentView.frame.size)
        let picSize = pictureSize
        TableCell.picture.frame = CGRect(x: 30, y: (contentView.frame.size.height - picSize.height)/3, width: picSize.width, height: contentView.frame.height/2)
        let pictureX = TableCell.picture.frame.origin.x + TableCell.picture.frame.width
        TableCell.location.frame = CGRect(x: pictureX + 30, y: (contentView.frame.size.height - picSize.height)/8, width: contentView.frame.width - 125, height: contentView.frame.height/2.5)
        let locationY = TableCell.location.frame.origin.y + TableCell.location.frame.height
        let locationX = TableCell.location.frame.origin.x + TableCell.location.frame.width
        TableCell.average.frame = CGRect(x: locationX - 45, y: TableCell.location.frame.origin.y, width: contentView.frame.width/10, height: contentView.frame.height/2.5)
        TableCell.date.frame = CGRect(x: TableCell.location.frame.origin.x, y: locationY, width: contentView.frame.width/5.5, height: contentView.frame.height/2.5)
        let dateX = TableCell.date.frame.origin.x + TableCell.date.frame.width
        TableCell.time.frame = CGRect(x: dateX, y: locationY, width: screenWidth/5.5 , height: 40)
        TableCell.averageDecibels.frame = CGRect(x: TableCell.average.frame.origin.x - contentView.frame.width/40, y: TableCell.date.frame.origin.y, width: screenWidth/5, height: contentView.frame.height/2.5)
        print(contentView.frame.height)
    }
}

