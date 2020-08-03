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
// let appDelegate = UIApplication.shared.delegate as! AppDelegate
class AddNewController: UIViewController, AVAudioRecorderDelegate{
    
    @IBOutlet weak var timerLabel: UILabel!
//    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var isConnected = false
    var audioBus = 0
    var node: AKNode!
    var recorder: AKNodeRecorder!
     var player: AKAudioPlayer!
//    var player: AKPlayer!
//    var player: AKAudioPlayer!
    var oscMixer: AKMixer!
    var tape: AKAudioFile!
    
   
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
//    var meterTimer2: Timer!
      var recordingSession: AVAudioSession!
      var audioRecorder:AVAudioRecorder!
      var audioPlayer: AVAudioPlayer!
      var decibelsArray:[Float] = [];
   
     @IBOutlet weak var gaugeView: GaugeView!
    @IBOutlet weak var counterLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
     @objc func updateAudioMeter(timer:Timer){
        if !(AudioKit.output == nil){

                     }
            }
        
                
                private struct Constants {
                  static let plusLineWidth: CGFloat = 3.0
                  static let plusButtonScale: CGFloat = 0.6
                  static let halfPointShift: CGFloat = 0.5
                }


    
    override func viewDidLoad() {
           super.viewDidLoad()
        createAReportButton.layer.cornerRadius = 20
//        stopButton.isHidden = true
//        playButton.isHidden = true
        
        
         counterLabel.text = String(gaugeView.counter) + "db"
        recordingSession = AVAudioSession.sharedInstance()
           // Do any additional setup after loading the view.
        
        
        if let number: Int = UserDefaults.standard.object(forKey: "recordings") as? Int {
                recordings = number
               }
        
        AVAudioSession.sharedInstance().requestRecordPermission{(hasPermission) in
                if hasPermission{
                    print("Accepted")
                }
        }
        
        AKSettings.audioInputEnabled = true
        let tape = try! AKAudioFile()
        player = try! AKAudioPlayer(file: tape)
//         player = try! AKAudioPlayer(file: tape)
              mic = AKMicrophone()
              tracker = AKFrequencyTracker.init(mic)
              silence = AKBooster(tracker,gain:0)
          oscMixer = AKMixer(player,silence)
//              AudioKit.output = silence
     
        

    
//              initMicrophone()
//                  if AudioKit.output == nil{
                     if !isConnected{
                        AKSettings.sampleRate = 44100


                             // Link the microphone note to the output of AudioKit with a volume of 0.
//                             AudioKit.output = AKBooster(mic, gain:0)
                          AudioKit.output = oscMixer

                             // Start AudioKit engine
                             try! AudioKit.start()

                             // Add a tap to the microphone
                             mic.avAudioNode.installTap(
                                 onBus: audioBus, bufferSize: AVAudioFrameCount(bufferSize), format: nil // I choose a buffer size of 1024
                             ) { [weak self] (buffer, _) in //self is now a weak reference, to prevent retain cycles

                                 // We try to create a strong reference to self, and name it strongSelf
                         //        guard let strongSelf = self else {
                         //          print("Recorder: Unable to create strong reference to self #1")
                         //          return
                         //        }
                                 
                                 buffer.frameLength = AVAudioFrameCount(bufferSize)
                                 
                                 let offset = Int(buffer.frameCapacity - buffer.frameLength)
                                 if let tail = buffer.floatChannelData?[0] {
                                   // We convert the content of the buffer to a swift array
                                     let samples = Array(UnsafeBufferPointer(start: &tail[offset], count: bufferSize))
                                     let arr = apply(dctMultiplier: EqualizationFilters.dctHighPass, toInput: samples)
                                    let array = decibelsConvert(array: arr)
                                    let decibels = applyMean(toInput: array)
                                    
                                    let minimumDecibels = Int(getMin(array: array))
                                    let maximumDecibels = Int(getMax(array: array))
                                    self!.keepDoing(decibels: decibels, min: minimumDecibels, max: maximumDecibels)
//                                    self!.keepDoing(decibels: decibels)

                                     
                                    
                        
                                 }


                                 }
                                          recordings += 1
                 
//                                          let filename = getDirectory().appendingPathComponent("\(recordings).m4a")

//                   print("file path \(filename)")
//                                          let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey:0, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
                    
                                          do{
//                                             let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey:0, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
//                                            file = try AKAudioFile(forWriting: filename, settings: settings, commonFormat: .pcmFormatFloat32, interleaved: false)
//
//                                           print("file name \(file)")
                                            
//                                            let filename = getDirectory().appendingPathComponent("\(recordings).m4a")
//                                                                    tape = try AKAudioFile(forWriting: filename, settings: settings, commonFormat: .pcmFormatFloat32, interleaved: false)
                                            
                                            recorder = try AKNodeRecorder(node: oscMixer, file: tape)
                                            try recorder.record()
                                            print("this is the tape url")
                                            print(tape.url)
                                            
                                            print("This is the audiofile url of the recorder")
                                            print(recorder.audioFile!.url)
                                            checking = returningFile(file: tape)
                                            
                                          
//                                            AKLog((recorder.audioFile?.directoryPath.absoluteString)!)
                                           

//                                                          AKLog((recorder.audioFile?.fileNamePlusExtension)!)
                                            
                                            
                                            
//                                              audioRecorder = try AVAudioRecorder(url: filename, settings: settings);
//                                              audioRecorder.delegate = self;
//                                              audioRecorder.isMeteringEnabled = true;
//                                              audioRecorder.record()
                                              meterTimer = Timer.scheduledTimer(timeInterval:0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats: true)
                      //                       let decibels = audioRecorder.averagePower(forChannel: 0);

                      //                        recordButton.setTitle("Stop Recording", for:.normal)
                                              let context = appDelegate.persistentContainer.viewContext
                                                               
                                              let entity = NSEntityDescription.entity(forEntityName: "Audio", in: context)
                                              let newTask = NSManagedObject(entity: entity!, insertInto: context)
                                                           
                                              newTask.setValue("\(recordings)",forKey: "recordings")
              //                                newTask.setValue(filename, forKey: "path")
                                              UserDefaults.standard.set(recordings, forKey: "recordings");
              //                                  meterTimer2 = Timer.scheduledTimer(timeInterval:0.1, target:self, selector:#selector(self.keepDoing), userInfo:nil, repeats: true)
              //
                                              do{
                                                      try context.save()
                                              }
                                              catch{
                                                      print("failed saving")
                                              }
                                                let _ = navigationController?.popViewController(animated: true)
                                          }
                                          catch{
                                              print("Something went wrong")
                                          }
                                        
                                      }
        
 self.isConnected = true
}
    @objc func keepDoing(decibels: Int, min: Int, max: Int){
                DispatchQueue.main.async{
//
   
                    self.gaugeView.counter = decibels
                    self.counterLabel.text = String(decibels) + " db"
                    self.avgDecibels.text = String(decibels) + " db"
                    self.minDecibels.text = String(min) + " db"
                    self.maxDecibels.text = String(max) + " db"
   
                    
                }
        
            }
    
    
    @IBAction func play(_ sender: Any) {
        do{

//            print(checking.url)
        
//            let playing = try AKAudioFile(forReading: checking.url)
            let playing = try AKAudioFile(forReading: checking.url)
//            player = try AKPlayer(audioFile: playing)
            player = try AKAudioPlayer(file: playing)
            print("in the play action this is the checking url")
            print(playing.url)
//             player = try AKAudioPlayer(file: checking)
           
//    let delay = AKDelay(player)
//    delay.time = 0.1
//            mic = AKMicrophone()
//            tracker = AKFrequencyTracker.init(player)
//            silence = AKBooster(tracker,gain:1)

            
//            let mix = AKMixer(player)
//            AudioKit.output = mix
//            player.connect(to: oscMixer)
                AudioKit.output = player
               try AudioKit.start()
           
            
//            player.start()
//            player.play()
           
        
        }
        catch{
            print("catching the error")
            print(error)
        }


    }
    
    func returningFile(file: AKAudioFile) -> AKAudioFile{
        return file
    }
    
    @IBAction func stop(button: UIButton) {
//        button.isSelected.toggle()
//        if stop.isSelected{
//                returningFileAgain(file: tape)
//
//                    }
        do{
              mic.stop()
            recorder.stop()
            
//            mic.stop()
            try AudioKit.stop()
            
            let dur = String(format: "%0.3f seconds", recorder.recordedDuration)

                      AKLog("Stopped. (\(dur) recorded)")
            
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func createReport(_ sender: Any) {
       
        do {
            try AudioKit.stop()
           
        }
        catch{
            print(error)
        }
        self.isConnected = false
                                 meterTimer.invalidate()
                                 UserDefaults.standard.set(recordings, forKey: "recordings")
     
    }
    
}
