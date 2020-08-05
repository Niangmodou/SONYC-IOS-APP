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
var checking: AKAudioFile!

let bufferSize = 1024
let calibrationOffset = 135
var file: AKAudioFile!
var mic: AKMicrophone!
class AddNewController: UIViewController, AVAudioRecorderDelegate{
    
    
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var isConnected = false
    var audioBus = 0
    var recorder: AKNodeRecorder!
    var player: AKAudioPlayer!
    var oscMixer: AKMixer!
    var tape: AKAudioFile!
    var paths: [NSManagedObject]!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var stop: UIButton!
    
    @IBOutlet weak var minDecibels: UILabel!
    @IBOutlet weak var avgDecibels: UILabel!
    @IBOutlet weak var maxDecibels: UILabel!
    @IBOutlet weak var createAReportButton: UIButton!
    @IBOutlet weak var decibelsLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    var recordings = 0
    var meterTimer: Timer!
    var recordingSession: AVAudioSession!
    
    @IBOutlet weak var gaugeView: GaugeView!
    @IBOutlet weak var counterLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @objc func updateAudioMeter(timer:Timer){
        if !(AudioKit.output == nil){
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAReportButton.layer.cornerRadius = 20
        
        
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
        //the audioFile the recording will record to
        let tape = try! AKAudioFile()
        
        //credit to : https://stackoverflow.com/questions/50805268/audiokit-how-to-get-real-time-floatchanneldata-from-microphone
        //^from Aurelius Prochazka
        //the microphone
        mic = AKMicrophone()
        
        //frequency tracker
        tracker = AKFrequencyTracker.init(mic)
        
        //booster
        silence = AKBooster(tracker,gain:0)
        
        //mixer
        oscMixer = AKMixer(silence)
        // ending credit above^
        
        if !isConnected{
            //AKSettings sample Rate
            AKSettings.sampleRate = 44100
            
            
            
            
            //the AudioKit output
            AudioKit.output = oscMixer
            
            // Start AudioKit engine
            try! AudioKit.start()
            
            //credit to: https://stackoverflow.com/questions/50805268/audiokit-how-to-get-real-time-floatchanneldata-from-microphone
            //^ from Aurelius Prochazka
            // Add a tap to the microphone
            mic.avAudioNode.installTap(
                onBus: audioBus, bufferSize: AVAudioFrameCount(bufferSize), format: nil // I choose a buffer size of 1024
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
                    self!.keepDoing(decibels: decibels, min: minimumDecibels, max: maximumDecibels)
                }
                
                
            }
            
            do{
                //increase the amount of recordings
                recordings += 1
                
                 //records to tape, takes in a node (the mixer)
                recorder = try AKNodeRecorder(node: oscMixer, file: tape)
                //starts recording
                try recorder.record()
                
                
                //continously updates the AudioMeter while the recording is happening
                meterTimer = Timer.scheduledTimer(timeInterval:0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats: true)
                
                //saving data to core data -> allows for retrieval when the app closes and opens up again
                let context = appDelegate.persistentContainer.viewContext
                
                //the entity that was made in the SonycApp.xcdatamodeld (Audio)
                let entity = NSEntityDescription.entity(forEntityName: "Audio", in: context)
                
                //the object of the entity
                let newTask = NSManagedObject(entity: entity!, insertInto: context)
                
                
                //set and save the recording number of the file
                newTask.setValue("\(recordings)",forKey: "recordings")
                UserDefaults.standard.set(recordings, forKey: "recordings");
                
                
                do{
                    //save the changes made to the persistent container to save the changes to the files/information being saved
                    try context.save()
                }
                catch{
                    print("failed saving")
                }
                let _ = navigationController?.popViewController(animated: true)
                //end of core data saving
            }
            catch{
                print(error)
            }
            
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
    
    //temporary play button
    @IBAction func play(_ sender: Any) {
        do{
            
            //the audio file that will be connected to the player , that is read at the url that the recorder records to
            let playing = try AKAudioFile(forReading: recorder.audioFile!.url)
            
            //the player is connected to the playing file
            player = try AKAudioPlayer(file: playing)
            
            //the audioKit output is the player
            AudioKit.output = player
            try AudioKit.start()
            //
            //starts and plays the player
            player.start()
            player.play()
            
            
        }
        catch{
            print(error)
        }
        
        
    }
    //temporary stop button
    @IBAction func stop(button: UIButton) {
        do{
            //stop the mic
            mic.stop()
            //stop the recorder
            recorder.stop()
            
            //stops the AudioKit
            try AudioKit.stop()
            
            //checking how long the recording was for
            let dur = String(format: "%0.3f seconds", recorder.recordedDuration)
            AKLog("Stopped. (\(dur) recorded)")
            
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func createReport(_ sender: Any) {
        
        do {
            //stop the audioKit
            try AudioKit.stop()
            
        }
        catch{
            print(error)
        }
        self.isConnected = false
        
        //stops the timer
        meterTimer.invalidate()
        //save the amount of recordings that were recorded
        UserDefaults.standard.set(recordings, forKey: "recordings")
        
    }
    
}
