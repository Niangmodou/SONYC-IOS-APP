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
import Accelerate
import AudioToolbox
import AudioKit

//array full of the views/cards that will show the recording details of each recording.
var viewArray: [UIView]!

class SavedRecordings: UITableViewController{
    var average: String!
    var dateStored: String!
    var timeStored: String!
    var audioCards = [NSManagedObject]()
    
    @IBOutlet var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //does not show the cells that are not in use
        myTableView.tableFooterView = UIView()
    
        
        
    }
       override func viewDidAppear(_ animated: Bool) {
            let context = appDelegate.persistentContainer.viewContext
            
            //requesting the data that is stored
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Audio")
            request.returnsObjectsAsFaults = false
                    do{
                        let result = try context.fetch(request)
                        for data in result as! [NSManagedObject]{
                            self.audioCards.append(data)
                            //                self.decibelsArray.append(data)
                        }
                    }
                    catch{
                        print("failed")
                    }
            //reloads the table view to see the changes
//            print(audioFiles.count)
            myTableView.reloadData()
        }
    
    //shows the cards of the recordings that were already made
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioCards.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "saved", for: indexPath) as! TableCell
        
        average = (newTask.value(forKey: "averageDec") as! String)

        dateStored = (newTask.value(forKey: "date") as! String)
        timeStored = (newTask.value(forKey: "time") as! String)
        
        cell.avgDecibels.text = average + " db"
        cell.dateAndTimeLabel.text = dateStored + " " + timeStored
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                if editingStyle == .delete {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    context.delete(self.audioCards[indexPath.row])
                    
                    do{
                             try context.save()
                             self.audioCards.removeAll()
                             UserDefaults.standard.set(audioCards.count, forKey: "savedRecording");
                             self.myTableView.reloadData()
                             
                         }
                         catch{
                             print("problem")
                         }
                }
        
    }
    
}
