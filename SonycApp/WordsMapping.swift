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
    wordsToImage["Angry"] = UIImage(named: "Icon_Angry Face");
    wordsToImage["Meh"] = UIImage(named: "Icon_meh face");
    wordsToImage["Annoyed"] = UIImage(named: "Icon_Annoyed Face");
    wordsToImage["Happy"] = UIImage(named: "Icon_Happy Face");
    wordsToImage["Dizzy"] = UIImage(named: "Icon_Dizzy Face");
    wordsToImage["Frustrated"] = UIImage(named: "Frustrated face");
    
    wordsToImage[" Parenting"] = UIImage(named: "Icon_Parenting");
    wordsToImage[" Resting"] = UIImage(named: "Icon_Resting man");
    wordsToImage[" Sleeping"] = UIImage(named: "Icon_Sleeping man");
    wordsToImage[" Walking"] = UIImage(named: "Icon_Walking");
    wordsToImage[" Working"] = UIImage(named: "Icon_Working man");
    
    wordsToImage["Home"] = UIImage(named: "Icon_Indoor");
    wordsToImage["Elsewhere"] = UIImage(named: "Icon_Outdoor");
}
