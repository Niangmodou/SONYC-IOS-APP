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

let bufferSize = 1024
let calibrationOffset = 135
var mic: AVAudioInputNode!
var audioEngine: AVAudioEngine!
var micTapped = false
var recorder: AVAudioRecorder!
var playerNode = AVAudioPlayerNode()
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
    
    //the amounts of decibels
    @IBOutlet weak var minDecibels: UILabel!
    @IBOutlet weak var avgDecibels: UILabel!
    @IBOutlet weak var maxDecibels: UILabel!
    //stops the recording if it is stronger than 10 seconds
    @IBOutlet weak var createAReportButton: UIButton!
    var recordingSession: AVAudioSession!
    //the gaugeView
    @IBOutlet weak var gaugeView: GaugeView!
    //the counter label that shows the amount of decibels coming in
    @IBOutlet weak var counterLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAReportButton.layer.cornerRadius = 20
        audioEngine = AVAudioEngine()
        //the input to the audioEngine is the microphone
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
        //deals with the tap of the microphone
        if micTapped {
            mic.removeTap(onBus: 0)
            micTapped = false
            return
        }
        //AKSettings sample Rate
        AKSettings.sampleRate = 44100
        
        let micFormat = mic.inputFormat(forBus: audioBus)
        //installs the tap on the microphone
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
                
                //applying the filter to the samples
                //also multiplying the audio samples array by the dctHighPass array for float values: dctHighPass array -> interpolatedVectorFrom(magnitudes:  [0,   0,   1,    1], indices:     [0, 340, 350, 1024], count: bufferSize)
                let arr = apply(dctMultiplier: EqualizationFilters.dctHighPass, toInput: samples)
                
                //does the spl calculations
                let array = decibelsConvert(array: arr)
                
                //finds the average decibels
                let decibels = applyMean(toInput: array)
                
                
                //gets the minimum decibel value from the array of audio samples
                let minimumDecibels = Int(getMin(array: array))
                //gets the maximum decibel value from the array of audio samples
                let maximumDecibels = Int(getMax(array: array))
                //gets the average amount of decibels from the array of audio samples
                let avgDec = Int(getAvg(decibels: decibels))
                //if the recorder is recording, find the average, minimum, and maximum decibels. Also stores those values in core data
                if recorder.isRecording{
                    self!.keepDoing(decibels: avgDec, min: minimumDecibels, max: maximumDecibels)
                    newTask.setValue(String(avgDec), forKey: "averageDec")
                    newTask.setValue(String(minimumDecibels), forKey: "min")
                    newTask.setValue(String(maximumDecibels), forKey: "max")
                }
                
            }
            
            
        }
        //changes the microphone tapping to true
        micTapped = true
        //starts the avaudioengine if it was not already started
        startEngine()
        
        
        do{
            //tries to start the audioEngine
            try audioEngine.start()
            //increase the amount of recordings
            recordings += 1
            //the name of the files
            let name = "\(recordings).m4a"
            //the path of where the file is
            let filename = getDirectory().appendingPathComponent(name)
            //settings array for recording to the audio file
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey:1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            //records to the filename
            recorder = try AVAudioRecorder(url: filename, settings: settings)
            //starts recording for 10 seconds
            recorder.record(forDuration: 10)
            //when the 10 seconds is up, if it was not stopped before, the recorder is stopped and it goes to a new screen
            tenSecondsUp()
            
            
            //set and save the recording number of the file
            newTask.setValue("\(recordings)",forKey: "recordings")
            //save the name of the the audio file
            newTask.setValue(name, forKey: "path")
            UserDefaults.standard.set(recordings, forKey: "recordings");
            //gets the date of when the recording takes place
            let dateNow = getDate()
            //gets the time of when the recording takes place
            let timeNow = getTime()
            //stores the date and time in core data
            newTask.setValue(dateNow, forKey: "date")
            newTask.setValue(timeNow, forKey: "time")
            //saves the data to the persistent container to be accessed later
            savingData()
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
            //displays the decibels values when the recorder is recording
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
    }
    //goes to the next screen when the 10 seconds is over
    func tenSecondsUp(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.nextScreen()
        }
    }
    //goes to the afterRecord screen that shows the map to store other information for the audiofile
    func nextScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "map") ; //afterRecord is the storyboard ID
        self.present(vc, animated: true, completion: nil);
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

//takes in a float array and returns a single float
func getAvg(decibels: Float)-> Float{
    if (decibels >= 0 && decibels <= 200){
        avgArray.append(decibels)
    }
    let sumArray = avgArray.reduce(0, +)
    let avg = sumArray/avgArray.count
    return Float(avg)
    
}

//function to get the date
func getDate() -> String{
    let date = Date()
    let format = DateFormatter()
    format.dateFormat = "MMM dd"
    let result = format.string(from: date)
    return result
}

//function to get the time
func getTime() -> String{
    let date = Date()
    let time = DateFormatter()
    time.dateFormat = "h:mm"
    let newString = time.string(from: date)
    return newString
}

//function to save the data in core data
func savingData(){
    do{
        //save the changes made to the persistent container to save the changes to the files/information being saved
        try context.save()
    }
    catch{
        print("failed saving")
        print(error)
    }
}
