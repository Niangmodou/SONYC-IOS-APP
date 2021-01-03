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
import SideMenu

//array full of the views/cards that will show the recording details of each recording.
var viewArray: [UIView]!
var audioCards = [NSManagedObject]()
var positionRecording: Int!;
//the select button is not selected
var buttonSelected = false;

class SavedRecordings: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var average: String!
    var dateStored: String!
    var timeStored: String!
    var locationImage: String!
    var barTool = UIBarButtonItem.init()
    var barTool2 = UIBarButtonItem.init()
//    var hamburgerBarTool = UIBarButtonItem.init()
    let cancelButton = UIButton.init()
    let selectButton = UIButton.init()
    let noRecordingsLabel = UILabel.init()
    var sideMenu: SideMenuNavigationController?
    var hamburgerButton = UIButton.init()
    
    @IBOutlet var hamburgerBarTool: UIBarButtonItem!
    @IBOutlet var myTableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "saved", for: indexPath) as! TableCell
        positionRecording = indexPath.row
        cell.average.text = "Avg"
        cell.average.textColor = UIColor.black
        cell.date.text = (audioCards[indexPath.row].value(forKey: "date") as? String)
        cell.date.textColor = UIColor.black
        cell.averageDecibels.text = (audioCards[indexPath.row].value(forKey: "averageDec") as? String ?? "no avg") + " db"
        cell.averageDecibels.textColor = UIColor.black
        cell.time.text = (audioCards[indexPath.row].value(forKey: "time") as? String)
        cell.time.textColor = UIColor.black
        cell.picture.image = wordsToImage[audioCards[indexPath.row].value(forKey: "noiseType") as? String ?? "other"]
        
        cell.picture.backgroundColor = UIColor.white
        
//        cell.location.text = (audioCards[indexPath.row].value(forKey: "reportAddress") as? String)
        cell.location.text = "PlaceHolder"
        cell.location.textColor = UIColor.black
        savingData()
        let _ = navigationController?.popViewController(animated: true)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //does not show the cells that are not in use
        myTableView.tableFooterView = UIView()
        //allows the tableview to be edited for the multiple selection
        myTableView.allowsMultipleSelectionDuringEditing = true
        
        
        sideMenu = SideMenuNavigationController(rootViewController: MenuListController())
        sideMenu?.leftSide = true
        sideMenu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        cancelButton.frame = CGRect(x: screenWidth/60, y: 0, width: screenWidth/3, height: screenHeight/30)
        cancelButton.titleLabel?.textColor = UIColor.black
        cancelButton.titleLabel?.text = "Cancel"
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        let cancelButtonX = cancelButton.frame.width + cancelButton.frame.origin.x
        selectButton.frame = CGRect(x: cancelButtonX + screenWidth/3, y: 0, width: screenWidth/3, height: screenHeight/30)
        selectButton.addTarget(self, action: #selector(selectAndDelete(button:)), for: .touchUpInside)
        selectButton.titleLabel?.textColor = UIColor.black
        selectButton.titleLabel?.text = "Select"
        
        
        
        barTool = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction(_:)))
        barTool2 = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectAndDelete(button:)))
        hamburgerBarTool = UIBarButtonItem(image: UIImage(named: "Hamburger.png"), style: .plain, target: self, action: #selector(TappedHamburger(_:)))
        hamburgerBarTool.image = UIImage(named: "Hamburger.png");
        
        barTool.tintColor = UIColor.black
        barTool2.tintColor = UIColor.black
        hamburgerBarTool.tintColor = UIColor.black
        
        self.navigationItem.leftBarButtonItem = hamburgerBarTool
        self.navigationItem.rightBarButtonItem = barTool2
        
        
        
        if(selectButton.titleLabel?.text == "Select"){
            cancelButton.isHidden = true
        }
    }
    
    @objc func TappedHamburger(_ sender: Any){
        present(sideMenu!, animated: true)
    }
    
    
    @objc func cancelAction(_ sender: Any) {
        //makes sure the the table view cannot be editing anymore
        self.myTableView.setEditing(false, animated: true)
        cancelButton.isHidden = true
        //deselects and un-highlights the select button
        self.navigationItem.leftBarButtonItem = nil
        barTool2.title = "Select"
        
    }
    //    //action for selecting mutiple table cells to do a mutliple deleting of data
    @objc func selectAndDelete(button: UIBarButtonItem) {
        //allows the table view to be edited
        self.myTableView.setEditing(true, animated: true)
        self.navigationItem.leftBarButtonItem = barTool
        button.title = "Delete"
        //shows that the select button is selected
        buttonSelected = true
        
        if let selectedRows = myTableView.indexPathsForSelectedRows {
            //temporary array to hold the audio files that need to be deleted
            var tempAudioCards = [NSManagedObject]()
            for indexPath in selectedRows  {
                tempAudioCards.append(audioCards[indexPath.row])
            }
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let context = appDelegate.persistentContainer.viewContext
            for item in tempAudioCards {
                if let index = audioCards.firstIndex(of: item) {
                    do{
                        //delets the file from core data
                        context.delete(audioCards[index])
//                        childContext.delete(audioCards[index])
                        try context.save()
//                        try childContext.save()
                        audioCards.remove(at: index)
                        self.myTableView.reloadData()
                        cancelButton.isHidden = true
                        self.navigationItem.leftBarButtonItem = nil
                        barTool2.title = "Select"
                    }
                    catch{
                        print(error)
                    }
                }
            }
        }
        if(audioCards.count == 0){
            noRecordingsLabel.frame = CGRect(x: screenWidth/2 - (screenWidth/3)/1.6, y: screenHeight/2 - (screenHeight/10), width: screenWidth/2, height: screenHeight/20)
            noRecordingsLabel.font = UIFont.boldSystemFont(ofSize: 30)
            noRecordingsLabel.textColor = UIColor.gray
            noRecordingsLabel.text = "No Recordings"
            self.view.addSubview(noRecordingsLabel)
            cancelButton.isHidden = true
            self.navigationItem.leftBarButtonItem = nil
            barTool2.title = "Select"
        }
    }
    //
    override func viewDidAppear(_ animated: Bool) {
        //persistentContainer
//        let context = appDelegate.persistentContainer.viewContext
        
        //requesting the data that is stored
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Audio")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
//            let result = try childContext.fetch(request)
            for data in result as! [NSManagedObject]{
                //if the audioFile is not in core data, add it
                if (!audioCards.contains(data) && (data.value(forKey: "averageDec") != nil)){
                    audioCards.append(data)
                }
            }
            if(audioCards.count == 0){
                noRecordingsLabel.frame = CGRect(x: screenWidth/2 - (screenWidth/3)/1.6, y: screenHeight/2 - (screenHeight/10), width: screenWidth/2, height: screenHeight/20)
                noRecordingsLabel.textColor = UIColor.gray
                noRecordingsLabel.font = UIFont.boldSystemFont(ofSize: 30)
                noRecordingsLabel.text = "No Recordings"
                self.view.addSubview(noRecordingsLabel)
                cancelButton.isHidden = true
                self.navigationItem.leftBarButtonItem = nil
                barTool2.title = "Select"
            }
        }
        catch{
            print("failed")
        }
        //reloads the table view to see the changes
        myTableView.reloadData()
    }
    
    
    //shows the cards of the recordings that were already made
    func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioCards.count;
    }
    
    
    //gets the element that is being accessed
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //have the index be the same as the indexPath.row
        positionRecording = indexPath.row
        //only goes to the recording details screen if the select button was not pressed so deleting will not occur
        if (buttonSelected == false){
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let vc = storyboard.instantiateViewController(withIdentifier: "recordingDetailsSaved") ; // recordings the storyboard ID
            //            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let context = appDelegate.persistentContainer.viewContext
            //deletes the audioFile from core data
            context.delete(audioCards[indexPath.row])
//            childContext.delete(audioCards[indexPath.row])
            
            do{
                //save that update
                try context.save()
//                try childContext.save()
                //remove the audioFile from the array
                audioCards.remove(at: indexPath.row)
                self.myTableView.reloadData()
                if(audioCards.count == 0){
                    noRecordingsLabel.frame = CGRect(x: screenWidth/2 - (screenWidth/3)/1.6, y: screenHeight/2 - (screenHeight/10), width: screenWidth/2, height: screenHeight/20)
                    noRecordingsLabel.font = UIFont.boldSystemFont(ofSize: 30)
                    noRecordingsLabel.textColor = UIColor.gray
                    noRecordingsLabel.text = "No Recordings"
                    self.view.addSubview(noRecordingsLabel)
                    cancelButton.isHidden = true
                    self.navigationItem.leftBarButtonItem = nil
                    barTool2.title = "Select"
                }
                
            }
            catch{
                print("problem")
            }
        }
        
        
    }
}
