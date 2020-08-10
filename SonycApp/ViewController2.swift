//
//  ViewController2.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 7/23/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//
import Foundation
import UIKit
import CoreData
import AVFoundation
import Accelerate
import AudioToolbox
import AudioKit
var position: Int = 0
var reading: AKAudioFile!
let appDelegate = UIApplication.shared.delegate as! AppDelegate
var audioFiles = [NSManagedObject]()
class ViewController2: UITableViewController {
    var audioFiles = [NSManagedObject]()
    var decibelsArray = [NSManagedObject]()
    var recordingSession: AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var player: AKAudioPlayer!
    
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
                self.audioFiles.append(data)
                //                self.decibelsArray.append(data)
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1)
        return cell
    }
    
    //stores the indexPath.row in the variable position to help with the transfer of the url over.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        position = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //            let path = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(self.audioFiles[indexPath.row])
            
            
            do{
                try context.save()
                self.audioFiles.removeAll()
                //                self.numbers.remove(at: indexPath.row)
                let context = appDelegate.persistentContainer.viewContext
                
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Audio")
                request.returnsObjectsAsFaults = false
                do{
                    let result = try context.fetch(request)
                    for data in result as! [NSManagedObject]{
                        self.audioFiles.append(data)
                    }
                }
                catch{
                    print("failed")
                }
                UserDefaults.standard.set(audioFiles.count, forKey: "recordings");
                self.myTableView.reloadData()
                
            }
            catch{
                print("problem")
            }
        }
        
    }
    
}

//getDirectiory of the file url
func getDirectory() -> URL{
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = paths[0]
    return documentDirectory
}

//transfersOver the url of the file being referenced
func transferOver() -> URL{
    return  getDirectory().appendingPathComponent("\(position + 1).m4a")
}
