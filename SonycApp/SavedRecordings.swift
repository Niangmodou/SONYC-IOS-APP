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
//the select button is not selected
var buttonSelected = false;

class SavedRecordings: UITableViewController{
    var average: String!
    var dateStored: String!
    var timeStored: String!
    var locationImage: String!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //does not show the cells that are not in use
        myTableView.tableFooterView = UIView()
        //allows the tableview to be edited for the multiple selection
        myTableView.allowsMultipleSelectionDuringEditing = true
        //hides the cancel button when it is pressed
        if(selectButton.titleLabel?.text == "Select"){
            cancelButton.isHidden = true
        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        //makes sure the the table view cannot be editing anymore
        self.myTableView.setEditing(false, animated: true)
        cancelButton.isHidden = true
        //deselects and un-highlights the select button
        selectButton.isSelected = false
        selectButton.isHighlighted = false
        
    }
    //action for selecting mutiple table cells to do a mutliple deleting of data
    @IBAction func selectAndDelete(button: UIButton) {
        //allows the table view to be edited
        self.myTableView.setEditing(true, animated: true)
        button.isSelected.toggle()
        //if the select button is pressed, it will turn into a delete button where you can select the audio files that you wish to delete
        button.setTitle("Delete", for: [.highlighted, .selected])
        //shows that the select button is selected
        buttonSelected = true
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            //temporary array to hold the audio files that need to be deleted
            var tempAudioCards = [NSManagedObject]()
            for indexPath in selectedRows  {
                tempAudioCards.append(audioCards[indexPath.row])
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            for item in tempAudioCards {
                if let index = audioCards.firstIndex(of: item) {
                    do{
                        //delets the file from core data
                        context.delete(audioCards[index])
                        try context.save()
                        audioCards.remove(at: index)
                        self.myTableView.reloadData()
                    }
                    catch{
                        print(error)
                    }
                }
            }
        }
        cancelButton.isHidden = false
        
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
        cell.dateAndTimeLabel?.text = (audioCards[indexPath.row].value(forKey: "date") as! String) + " " + (audioCards[indexPath.row].value(forKey: "time") as! String)
        cell.avgDecibels?.text = (audioCards[indexPath.row].value(forKey: "averageDec") as! String) + " db"
        cell.imageCard?.image = wordsToImage[audioCards[indexPath.row].value(forKey: "noiseType") as! String]
        cell.locationLabel?.text = (audioCards[indexPath.row].value(forKey: "reportAddress") as! String)
        return cell
    }
    
    //gets the element that is being accessed
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //have the index be the same as the indexPath.row
        positionRecording = indexPath.row
        //only goes to the recording details screen if the select button was not pressed so deleting will not occur
        if (buttonSelected == false){
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let vc = storyboard.instantiateViewController(withIdentifier: "recordingDetailsSaved") ; // recordings the storyboard ID
            self.present(vc, animated: true, completion: nil);
        }
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
