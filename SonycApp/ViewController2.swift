//
//  ViewController2.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 7/23/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//
//
import UIKit
import CoreData
import AVFoundation

var position: Int = 0
var audioFiles = [NSManagedObject]()
class ViewController2: UITableViewController {
    var recordingSession: AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    @IBOutlet var myTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //does not show the cells that are not in use
        myTableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //persistentContainer that is needed to use core data to store information within the app.
        let context = appDelegate.persistentContainer.viewContext
        
        //requesting the data that is stored
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Audio")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                audioFiles.append(data)
            }
        }
        catch{
            print("failed")
        }
        //reloads the table view to see the changes
        myTableView.reloadData()
    }
    
    //has the same number of cells as the amout of elements in the audioFiles array
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFiles.count;
    }
    
    //for the textLabel for the cells of the tables
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1)
        return cell
    }
    
    //stores the indexPath.row in the variable position to help with the transfer of the url over.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        position = indexPath.row
    }
    
    //for deleting elements out of the tableview
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(audioFiles[indexPath.row])
            
            do{
                //saves the context after deleting
                try context.save()
                audioFiles.removeAll()
                
                let context = appDelegate.persistentContainer.viewContext
                //fetching the data
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Audio")
                request.returnsObjectsAsFaults = false
                do{
                    let result = try context.fetch(request)
                    for data in result as! [NSManagedObject]{
                        audioFiles.append(data)
                    }
                }
                catch{
                    print("failed")
                }
                UserDefaults.standard.set(audioFiles.count, forKey: "recordings");
                //reloads the tableView
                self.myTableView.reloadData()
                
            }
            catch{
                print("problem")
            }
        }
        
    }
    
}
