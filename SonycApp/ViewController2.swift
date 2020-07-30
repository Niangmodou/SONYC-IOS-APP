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
//var path: URL!
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
//    var reverb:AKReverb!
    var player: AKAudioPlayer!

        @IBOutlet var myTableView: UITableView!

//        let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.tableFooterView = UIView()

    }

    override func viewDidAppear(_ animated: Bool) {
//            audioFiles = [NSManagedObject]()
            
            
            let context = appDelegate.persistentContainer.viewContext
            
            
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
            myTableView.reloadData()
        }
        
        override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
            return audioFiles.count;
            }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = String(indexPath.row + 1)
                return cell
            }

        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//                let path = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")
            let filename = getDirectory().appendingPathComponent("\(recordings).m4a")

                            
                             
                                      
                                            
            position = indexPath.row
                do{
//                     let file = try AKAudioFile(forWriting: filename, settings: settings, commonFormat: .pcmFormatFloat32, interleaved: false)
//                    let reverb = AKReverb()
//                    mic >>> reverb
//                    AudioKit.output = reverb
//                    try AudioKit.start()
                    reading = try AKAudioFile(forReading: filename)
                    player = try AKAudioPlayer(file: reading)
                    AudioKit.output = player
                    try AudioKit.start()
//                    audioPlayer = try AVAudioPlayer(contentsOf: path)
//                    audioPlayer.play()
        //            let displaying = audioPlayer?.averagePower(forChannel: 0)
        //            decibelsLabel.text = String(decibelsArray[indexPath.row]);


                }
                catch{
                    print(error)
                }
//            _ = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")
            
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

func getDirectory() -> URL{
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentDirectory = paths[0]
            return documentDirectory
        }
func transferOver() -> URL{
       return  getDirectory().appendingPathComponent("\(position + 1).m4a")
   }

//func place() -> AKAudioFile{
//    return  reading
//}
