//
//  AddNewController.swift
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

var decibelsAvg: Float!
var decibelsPeak: Float!
let bufferSize = 1024
let calibrationOffset = 135
var mic: AVAudioInputNode!
var audioEngine: AVAudioEngine!
var micTapped = false
var recorder: AVAudioRecorder!
var playerNode = AVAudioPlayerNode()
var duration: Float!
var big: Float = -1000
var small: Float = 100000
var maxArray: [Float] = [50]
var minArray: [Float] = [50]
var avgArray: [Float] = [50]
var avgDec: Int!
class AddNewController: UIViewController, AVAudioRecorderDelegate{
    var isConnected = false
    var audioBus = 0
    var tape: AVAudioFile!
    var paths: [NSManagedObject]!
    var testRecorder: AVAudioRecorder!
    
    @IBOutlet weak var minDecibels: UILabel!
    @IBOutlet weak var avgDecibels: UILabel!
    @IBOutlet weak var maxDecibels: UILabel!
    @IBOutlet weak var createAReportButton: UIButton!
    @IBOutlet weak var decibelsLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    
    @IBOutlet weak var gaugeView: GaugeView!
    @IBOutlet weak var counterLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAReportButton.layer.cornerRadius = 20
        audioEngine = AVAudioEngine()
        mic = audioEngine.inputNode
        //counterLabel will be the same as the gaugeView meter
        counterLabel.text = String(gaugeView.counter) + "db"
        
        recordingSession = AVAudioSession.sharedInstance()
        
        //keeps track of the up to date recordings
        if let number: Int = UserDefaults.standard.object(forKey: "recordings") as? Int {
            recordings = number
        }
        
        //permission for microphone
        AVAudioSession.sharedInstance().requestRecordPermission{(hasPermission) in
            if hasPermission{
                print("Accepted")
            }
        }
        
        AKSettings.audioInputEnabled = true
        
        if micTapped {
            mic.removeTap(onBus: 0)
            micTapped = false
            return
        }
        //        if !isConnected{
        //AKSettings sample Rate
        AKSettings.sampleRate = 44100
        
        let micFormat = mic.inputFormat(forBus: audioBus)
        mic.installTap(
            onBus: audioBus, bufferSize: AVAudioFrameCount(bufferSize), format: micFormat // I choose a buffer size of 1024
            //                 onBus: audioBus, bufferSize: AVAudioFrameCount(bufferSize), format: nil
        ) { [weak self] (buffer, _) in //self is now a weak reference, to prevent retain cycles
            
            
            buffer.frameLength = AVAudioFrameCount(bufferSize)
            
            let offset = Int(buffer.frameCapacity - buffer.frameLength)
            if let tail = buffer.floatChannelData?[0] {
                // convert the content of the buffer to a swift array
                
                //samples array that will hold the audio samples
                let samples = Array(UnsafeBufferPointer(start: &tail[offset], count: bufferSize))
                
                //ending credit above
                
                //applying the filter to the samples and applying calculations up to the log10 step
                //also multiplying the audio samples array by the dctHighPass array for float values: dctHighPass array -> interpolatedVectorFrom(magnitudes:  [0,   0,   1,    1], indices:     [0, 340, 350, 1024], count: bufferSize)
                
                let arr = apply(dctMultiplier: EqualizationFilters.dctHighPass, toInput: samples)
                
                //does the rest of the spl calculations
                let array = decibelsConvert(array: arr)
                
                //finds the average decibels
                let decibels = applyMean(toInput: array)
                
                
                //gets the minimum decibel value from the array of audio samples
                let minimumDecibels = Int(getMin(array: array))
                //gets the maximum decibel value from the array of audio samples
                let maximumDecibels = Int(getMax(array: array))
                
                let avgDec = Int(getAvg(decibels: decibels))
                //                self!.keepDoing(decibels: Int(decibels), min: minimumDecibels, max: maximumDecibels)
                if recorder.isRecording{
                    self!.keepDoing(decibels: avgDec, min: minimumDecibels, max: maximumDecibels)
                    newTask.setValue(String(avgDec), forKey: "averageDec")
                    newTask.setValue(String(minimumDecibels), forKey: "min")
                    newTask.setValue(String(maximumDecibels), forKey: "max")
                }
                
            }
            
            
        }
        micTapped = true
        startEngine()
        
        
        do{
            
            try audioEngine.start()
            //increase the amount of recordings
            recordings += 1
            
            let filename = getDirectory().appendingPathComponent("\(recordings).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey:1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            //records to tape, takes in a node (the mixer)
            recorder = try AVAudioRecorder(url: filename, settings: settings)
            //starts recording for 10 seconds
            recorder.record(forDuration: 10)
            
            
            //saving data to core data -> allows for retrieval when the app closes and opens up again
//            let context = appDelegate.persistentContainer.viewContext
            
            //the entity that was made in the SonycApp.xcdatamodeld (Audio)
//            let entity = NSEntityDescription.entity(forEntityName: "Audio", in: context)
            
            //the object of the entity
//            let newTask = NSManagedObject(entity: entity!, insertInto: context)
            
            //set and save the recording number of the file
            newTask.setValue("\(recordings)",forKey: "recordings")
            newTask.setValue(filename, forKey: "path")
            UserDefaults.standard.set(recordings, forKey: "recordings");
            let dateNow = getDate()
            let timeNow = getTime()
            
            newTask.setValue(dateNow, forKey: "date")
            newTask.setValue(timeNow, forKey: "time")
            
            
            do{
                //save the changes made to the persistent container to save the changes to the files/information being saved
                try context.save()
            }
            catch{
                print("failed saving")
                print(error)
            }
            let _ = navigationController?.popViewController(animated: true)
            //end of core data saving
        }
        catch{
            print(error)
        }
        
        //sets isConnected to true
        self.isConnected = true
    }
    //keeps updating the gauge values and the values of the min, avg, and max label values
    @objc func keepDoing(decibels: Int, min: Int, max: Int){
        DispatchQueue.main.async{
            
            self.gaugeView.counter = decibels
            //adds on the db text onto the number of the decibels converted to a string
            self.counterLabel.text = String(decibels) + " db"
            self.avgDecibels.text = String(decibels) + " db"
            self.minDecibels.text = String(min) + " db"
            self.maxDecibels.text = String(max) + " db"
        }
        
    }
    
    //stops the audioEngine and recorder
    //also stops the audioEngine and stored the stage of the recordings in the userDefaults
    @IBAction func createReport(_ sender: Any) {
        stopAndResetAudio()
        //        UserDefaults.standard.set(recordings, forKey: "recordings")
    }
    
}

//takes in a float array and returns a single float

func getMin(array: [Float]) -> Float{
    small = array.min()!
    if(small >= 0){
        minArray.append(small)
    }
    return minArray.min()!
}

//takes in a float array and returns a single float
func getMax(array: [Float]) -> Float{
    big = array.max()!
    if(big < 200){
        maxArray.append(big)
    }
    return maxArray.max()!
}

func getAvg(decibels: Float)-> Float{
    if (decibels >= 0 && decibels <= 200){
        avgArray.append(decibels)
    }
    let sumArray = avgArray.reduce(0, +)
    let avg = sumArray/avgArray.count
    return Float(avg)
    
}

func getDate() -> String{
    let date = Date()
    let format = DateFormatter()
    format.dateFormat = "MMM dd"
    let result = format.string(from: date)
    return result
}

func getTime() -> String{
    let date = Date()
    let time = DateFormatter()
    time.dateFormat = "h:mm"
    let newString = time.string(from: date)
    return newString
}
