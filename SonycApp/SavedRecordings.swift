//
//  SavedRecordings.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 8/9/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVFoundation
import AudioToolbox

//array full of the views/cards that will show the recording details of each recording.
var viewArray: [UIView]!
var audioCards = [NSManagedObject]()
var positionRecording: Int!;

class SavedRecordings: UITableViewController{
    var average: String!
    var dateStored: String!
    var timeStored: String!
    var locationImage: String!
    
    @IBOutlet var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //does not show the cells that are not in use
        myTableView.tableFooterView = UIView()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        //persistentContainer
        let context = appDelegate.persistentContainer.viewContext
        
        //requesting the data that is stored
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Audio")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                //if the audioFile is not in core data, add it
                if (!audioCards.contains(data)){
                    audioCards.append(data)
                }
            }
        }
        catch{
            print("failed")
        }
        //reloads the table view to see the changes
        myTableView.reloadData()
    }
    
    //shows the cards of the recordings that were already made
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioCards.count;
    }
    
    //customized cells based on the information stored in each audio file
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "saved", for: indexPath) as! TableCell
        //have the index be the same as the indexPath.row
        positionRecording = indexPath.row
        cell.dateAndTimeLabel.text = (audioCards[indexPath.row].value(forKey: "date") as! String) + " " + (audioCards[indexPath.row].value(forKey: "time") as! String)
        cell.avgDecibels.text = (audioCards[indexPath.row].value(forKey: "averageDec") as! String)
        cell.imageCard.image = wordsToImage[audioCards[indexPath.row].value(forKey: "locationType") as! String]
        return cell
    }
    
    //gets the element that is being accessed
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //have the index be the same as the indexPath.row
        positionRecording = indexPath.row
    }
    //size of the cell is 100 (height)
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            //deletes the audioFile from core data
            context.delete(audioCards[indexPath.row])
            
            do{
                //save that update
                try context.save()
                //remove the audioFile from the array
                audioCards.remove(at: indexPath.row)
                self.myTableView.reloadData()
                
            }
            catch{
                print("problem")
            }
        }
        
    }
    
}
