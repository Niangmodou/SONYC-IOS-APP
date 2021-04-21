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
import FloatingPanel

let bufferSize = 1024
var samplesArray: [Float] = []
let calibrationOffset = 93
var mic: AVAudioInputNode!
var audioEngine: AVAudioEngine!
var micTapped = false
var recorder: AVAudioRecorder!
var playerNode = AVAudioPlayerNode()
var big: Float = -1000
var small: Float = 100000
var maxArray: [Float] = [10]
var minArray: [Float] = [200]
var avgArray: [Float] = []
var avgDec: Int!
var decibelsHolderArray: [Float] = []
var timer: Timer!
let slidingUp = FloatingPanelController()

class AddNewController: UIViewController, AVAudioRecorderDelegate, FloatingPanelControllerDelegate{
    let minDecibels = UILabel.init()
    let avgDecibels = UILabel.init()
    let maxDecibels = UILabel.init()
    //stops the recording if it is stronger than 10 seconds
    let createAReportButton = UIButton.init(type: .custom)
    //the gaugeView
    let gaugeView = GaugeView.init()
    //the counter label that shows the amount of decibels coming in
    let counterLabel = UILabel.init()
    let currentSoundTitle = UILabel.init()
    let min = UILabel.init()
    let avg = UILabel.init()
    let max = UILabel.init()
    
    var isConnected = false
    var audioBus = 0
    var tape: AVAudioFile!
    var paths: [NSManagedObject]!
    var testRecorder: AVAudioRecorder!
    //checks if the slide up view is showing
    var isShowing = false;
    var recordingSession: AVAudioSession!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        currentSoundTitle.frame = CGRect(x: screenWidth/7, y: screenHeight/20, width: screenWidth - 30, height: screenHeight/35)
        currentSoundTitle.text = "Current Sound Level (dBA)"
        currentSoundTitle.font = UIFont.boldSystemFont(ofSize: 25)
        let currentSoundTitleLocationY = currentSoundTitle.frame.height + currentSoundTitle.frame.origin.y
        
        gaugeView.frame = CGRect(x: 15, y: currentSoundTitleLocationY + screenHeight/40, width: screenWidth - 30, height: screenHeight/1.8)
        gaugeView.counterColor = UIColor.specificBlue()
        gaugeView.outlineColor = UIColor.specificBlueFill()
        gaugeView.backgroundColor = UIColor.white
        gaugeView.outlineColor.setFill()
        gaugeView.draw(CGRect(x: 15, y: screenHeight/6, width: screenWidth - 30, height: screenHeight/2.3))
        
        let gaugeViewLocationX = gaugeView.frame.origin.x + gaugeView.frame.width
        let gaugeViewLocationY = gaugeView.frame.origin.y + gaugeView.frame.height
        min.frame = CGRect(x: gaugeView.frame.origin.x + screenWidth/9, y: gaugeViewLocationY, width: screenWidth/8, height: screenHeight/35)
        min.text = "Min"
        let minLocationX = min.frame.width + min.frame.origin.x
        let minLocationY = min.frame.height + min.frame.origin.y
        avg.frame = CGRect(x: minLocationX + screenWidth/6, y: gaugeViewLocationY, width: screenWidth/8, height: screenHeight/35)
        avg.text = "Avg"
        let avgLocationX = avg.frame.width + avg.frame.origin.x
        let avgLocationY = avg.frame.height + avg.frame.origin.y
        max.frame = CGRect(x: avgLocationX + screenWidth/6, y: gaugeViewLocationY, width: screenWidth/8, height: screenHeight/35)
        max.text = "Max"
        let maxLocationY = max.frame.height + max.frame.origin.y
        minDecibels.frame = CGRect(x: min.frame.origin.x - screenWidth/40, y: minLocationY + screenHeight/24, width: screenWidth/5, height: screenHeight/35)
        minDecibels.text = "0 db"
        avgDecibels.frame = CGRect(x: avg.frame.origin.x - screenWidth/40, y: avgLocationY + screenHeight/24, width: screenWidth/5, height: screenHeight/35)
        avgDecibels.text = "0 db"
        maxDecibels.frame = CGRect(x: max.frame.origin.x - screenWidth/40, y: maxLocationY + screenHeight/24, width: screenWidth/5, height: screenHeight/35)
        maxDecibels.text = "0 db"
        createAReportButton.frame = CGRect(x: 15, y: minLocationY + screenHeight/8, width: screenWidth - 30, height: screenHeight/20)
        createAReportButton.setTitle(" Create a Report", for: .normal)
        createAReportButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        createAReportButton.setTitleColor(UIColor.black, for: .normal)
        createAReportButton.layer.borderWidth = 1.0
        createAReportButton.layer.cornerRadius = 20
        createAReportButton.layer.borderColor = UIColor.black.cgColor
        createAReportButton.layer.backgroundColor = UIColor.buttonSelected().cgColor
        createAReportButton.addTarget(self, action: #selector(createReport(_:)), for: .touchUpInside)
        
        counterLabel.frame = CGRect(x: gaugeViewLocationX/2.3, y: gaugeViewLocationY/1.7, width: screenWidth/5, height: screenHeight/20)
        counterLabel.text = "0 db"
        
        self.view.addSubview(gaugeView)
        self.view.addSubview(currentSoundTitle)
        self.view.addSubview(min)
        self.view.addSubview(avg)
        self.view.addSubview(max)
        self.view.addSubview(minDecibels)
        self.view.addSubview(avgDecibels)
        self.view.addSubview(maxDecibels)
        self.view.addSubview(counterLabel)
        self.view.addSubview(createAReportButton)
        
        
        
        audioEngine = AVAudioEngine()
        //the input to the audioEngine is the microphone
        
        mic = audioEngine.inputNode
        
        
        //counterLabel will be the same as the gaugeView meter
        counterLabel.text = String(gaugeView.counter) + " db"
        
        recordingSession = AVAudioSession.sharedInstance()
        
        print(newTask.value(forKey: "reportAddress"), "addnewcontroller")
        
        do{
            try recordingSession.setPreferredSampleRate(48000)
        }
        catch{
            print(error)
        }
        
        
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
        
        //deals with the tap of the microphone
        if micTapped {
            mic.removeTap(onBus: 0)
            micTapped = false
            return
        }
        
        let micFormat = mic.inputFormat(forBus: audioBus)
        //installs the tap on the microphone
        mic.installTap(
            onBus: audioBus, bufferSize: AVAudioFrameCount(bufferSize), format: micFormat// I choose a buffer size of 1024
        ) { [weak self] (buffer, _)  in //self is now a weak reference, to prevent retain cycles
            
            let offset = Int(buffer.frameCapacity - buffer.frameLength)
            if let tail = buffer.floatChannelData?[0] {
                // convert the content of the buffer to a swift array
                //samples array that will hold the audio samples
                let samples = Array(UnsafeBufferPointer(start: &tail[offset], count: bufferSize))
                if samplesArray.count == 4096{
                    samplesArray = [];
                }
                samplesArray.append(contentsOf: samples)
                //ending credit above
                //only calculates the decibels when 4 arrays of samples are taken in
                if (samplesArray.count == 4096){
                    let arr1 = apply(dctMultiplier: EqualizationFilters.dctHighPass, toInput: samples)
                    //does the spl calculations
                    let array = decibelsConvert(array: arr1)
                    
                    //finds the average decibels
                    let decibels = applyMean(toInput: array)
                    
                    decibelsHolderArray.append(decibels)
                    //gets the minimum decibel value from the array of audio samples
                    let minimumDecibels = getMin(array: decibelsHolderArray)
                    //gets the maximum decibel value from the array of audio samples
                    let maximumDecibels = getMax(array: decibelsHolderArray)
                    //gets the average amount of decibels from the array of audio samples
                    let avgDec = getAvg(decibels: decibels)
                    //if the recorder is recording, find the average, minimum, and maximum decibels. Also stores those values in core data
                    if recorder.isRecording{
                        
                        self!.keepDoing(decibels: decibels, min: Float(minimumDecibels), max: Float(maximumDecibels))
                        newTask.setValue(String(format: "%.2f",avgDec), forKey: "averageDec")
                        newTask.setValue(String(format: "%.2f",minimumDecibels), forKey: "min")
                        newTask.setValue(String(format: "%.2f",maximumDecibels), forKey: "max")
                    }
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
//            savingData()
//            let _ = navigationController?.popViewController(animated: true)
            //end of core data saving
        }
        catch{
            print(error)
        }
        
        //sets isConnected to true
        self.isConnected = true
        
        guard let contentVC = storyboard?.instantiateViewController(identifier: "slideUp") as? SlideUpView
            else{
                return
        }
        //for the slide up panel
        slidingUp.delegate = self
        slidingUp.set(contentViewController: contentVC)
        slidingUp.addPanel(toParent: self)
        //hides the slide up panel until the recording session is finished
        slidingUp.hide()
        
    }
    //keeps updating the gauge values and the values of the min, avg, and max label values
    @objc func keepDoing(decibels: Float, min: Float, max: Float){
        DispatchQueue.main.async{
            //displays the decibels values when the recorder is recording
            self.gaugeView.counter = decibels
            //adds on the db text onto the number of the decibels converted to a string
            self.counterLabel.text = String(format: "%.1f",decibels) + " db"
            self.avgDecibels.text = String(format: "%.1f",decibels) + " db"
            self.minDecibels.text = String(format: "%.1f",min) + " db"
            self.maxDecibels.text = String(format: "%.1f",max) + " db"
        }
    }
    //stops the audioEngine and recorder
    //also stops the audioEngine and stored the stage of the recordings in the userDefaults
    @IBAction func createReport(_ sender: Any) {
        stopAndResetAudio()
        //shows the slide up panel when the recording is finished
        slidingUp.show()
        //the slideup view is showing
        isShowing = true
    }
    
    //shows the slideup panel after 10 seconds if it is not already showing
    func tenSecondsUp(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            if (self.isShowing == false){
                slidingUp.show()
            }
            micTapped = false
        }
    }
}

//takes in a float array and returns a single float
func getMin(array: [Float]) -> Float{
    small = array.min()!
    if(small >= 0){
        minArray.append(small)
    }
    var minimum = Double.infinity
    for num in minArray {
        if num < Float(minimum){
            minimum = Double(num)
        }
    }
    return Float(minimum)
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
    let avg = sumArray/Float(avgArray.count)
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

