//
//  WordsMapping.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 8/8/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//

import Foundation
import UIKit

//dictionary that will hold the image values of each button to display on the recording details
var wordsToImage = Dictionary<String, UIImage>();
class WordsMapping: UIViewController{
    override func viewDidLoad() {
    }
}
//populates the dictionary
//each button has a name assigned to it that will map to an image to put each on the recording details screen
func fillDict(){
    //face button mapping
    wordsToImage["Angry"] = UIImage(named: "Icon_Angry Face.png");
    wordsToImage["Meh"] = UIImage(named: "Icon_meh face.png");
    wordsToImage["Annoyed"] = UIImage(named: "Icon_Annoyed Face.png");
    wordsToImage["Happy"] = UIImage(named: "Icon_Happy Face.png");
    wordsToImage["Dizzy"] = UIImage(named: "Icon_Dizzy Face.png");
    wordsToImage["Frustrated"] = UIImage(named: "Frustrated face.png");
    
    //what the person is doing mapping
    wordsToImage[" Parenting"] = UIImage(named: "Icon_Parenting.png");
    wordsToImage[" Resting"] = UIImage(named: "Icon_Resting man.png");
    wordsToImage[" Sleeping"] = UIImage(named: "Icon_Sleeping man.png");
    wordsToImage[" Walking"] = UIImage(named: "Icon_Walking.png");
    wordsToImage[" Working"] = UIImage(named: "Icon_Working man.png");
    
    //location type mapping
    wordsToImage[" Home"] = UIImage(named: "Icon_Indoor.png");
    wordsToImage[" Elsewhere"] = UIImage(named: "Icon_Outdoor.png");
    wordsToImage[" Building"] = UIImage(named: "Logo_Building.png");
    wordsToImage[" Street"] = UIImage(named: "Logo_Dot.png");
    wordsToImage[" Report"] = UIImage(named: "Logo_311.png");
    
    //noisetype
    wordsToImage[" Construction"] = UIImage(named: "Logo_construction.png");
    wordsToImage[" NightLife"] = UIImage(named: "Logo_nightlife.png");
    wordsToImage[" Music"] = UIImage(named: "Logo_music.png");
    wordsToImage[" Delivery"] = UIImage(named: "Logo_truck.png");
    wordsToImage[" Garbage"] = UIImage(named: "Logo_garbage.png");
}
