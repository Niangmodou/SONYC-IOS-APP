//
//  PlayBackViewController.swift
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
import MessageUI

var audioPlay: AVAudioPlayer!
class PlayBackViewController: UIViewController, AVAudioRecorderDelegate, MFMessageComposeViewControllerDelegate{
    var feeling:String!
    var youAre:String!
    var min: String!
    var avg: String!
    var max: String!
    
    
    @IBOutlet weak var maxDecibelsLabel: UILabel!
    @IBOutlet weak var avgDecibelsLabel: UILabel!
    @IBOutlet weak var minDecibelsLabel: UILabel!
    @IBOutlet weak var youFeelImage: UIImageView!
    @IBOutlet weak var youAreImage: UIImageView!
    @IBOutlet weak var youAreLabel: UILabel!
    @IBOutlet weak var saveOnlyButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var gaugeView: GaugeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if recorder.isRecording{
            counterLabel.text = String(gaugeView.counter) + "db"
        }
        addingBorder(button: saveOnlyButton)
        saveOnlyButton.layer.borderColor = UIColor.faceSelected().cgColor
        curvingButton(button: saveOnlyButton)
        curvingButton(button: reportButton)
        feeling = (newTask.value(forKey: "faceButton") as! String)
        youAre = (newTask.value(forKey: "iAm") as! String)
        min = (newTask.value(forKey: "min") as! String)
        avg = (newTask.value(forKey: "averageDec") as! String)
        max = (newTask.value(forKey: "max") as! String)
        
        //information that will be stored in the recording details of the card
        //images and label for the file.
        youFeelImage.image = wordsToImage[feeling]
        youAreImage.image = wordsToImage[youAre]
        youAreLabel.text = newTask.value(forKey: "iAm") as? String
        dateLabel.text = newTask.value(forKey: "date") as? String
        timeLabel.text = newTask.value(forKey: "time") as? String
        minDecibelsLabel.text = min + " db"
        avgDecibelsLabel.text = avg + " db"
        maxDecibelsLabel.text = max + " db"
        
        
        
        
    }
    
    @objc func keepDoing(){
        
    }
    
    //have to connect the fastFoward and the rewind to the playerNode
    @IBAction func fastForward(_ sender: Any) {
        var time: TimeInterval = audioPlayer.currentTime
        time += 1.0 // Go forward by 1 second
        audioPlayer.currentTime = time
    }
    
    
    @IBAction func rewind(_ sender: Any) {
        var time: TimeInterval = audioPlayer.currentTime
        time -= 1.0 // Go back by 1 second
        audioPlayer.currentTime = time
    }
    
    //plays the file and shows the progress on the progress view.
    @IBAction func play(button: UIButton) {
        button.isSelected.toggle()
        if button.isSelected{
            playFile()
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
            progressView.setProgress(Float(audioPlay.currentTime/audioPlay.duration), animated: false)
        }
    }
    
    //updates the progress view while the audiofile is playing
    @objc func updateAudioProgressView(){
        if audioEngine.isRunning
        {
            progressView.setProgress(Float(audioPlay.currentTime/audioPlay.duration), animated: true)
            
        }
    }
    @objc func keep(decibels: Int, min: Int, max: Int){
        DispatchQueue.main.async{
            
            self.gaugeView.counter = decibels
            self.counterLabel.text = String(decibels) + " db"
        }
        
    }
    
    //auto function needed for the MFMessageComposeViewControllerDelegate to be used
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    
    //is connected to the report button
    //will send the recording details to 311
    @IBAction func sendText(_ sender: Any) {
        let controller = MFMessageComposeViewController()
        controller.messageComposeDelegate = self
        controller.body = "Testing Out"
        //the recipient will be 311
        controller.recipients = [""];
        if(MFMessageComposeViewController.canSendText()){
            self.present(controller, animated: true, completion: nil)
        }
        else{
            print("Can't send message");
        }
    }
    
//    @IBAction func saveOnly(_ sender: Any) {
//        count = count + 1
//    }
    
    
}

//converts the url of where the file is to an AVAudioFile format inorder to connect it to the playerNode.
func readableAudioFileFrom(url: URL) -> AVAudioFile {
    var audioFile: AVAudioFile!
    do {
        try audioFile = AVAudioFile(forReading: url)
    } catch { }
    return audioFile
}

//plays the file
//attaches the playerNode to the audioEngine and connects the node to the audioEngine's output node
//starts the engine if it was not already started
func playFile(){
    do{
        let playerNode = AVAudioPlayerNode()
        let audioFile = readableAudioFileFrom(url: transferOver())
        audioEngine.attach(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.outputNode, format: audioFile.processingFormat)
        startEngine()
        //scheduling the file to be played and removes the tap
        playerNode.scheduleFile(audioFile, at: nil) {
            playerNode.removeTap(onBus: 0)
        }
        //installing the tap on the playerNode
        playerNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(bufferSize), format: playerNode.outputFormat(forBus: 0)) { (buffer, when) in
            let sampleData = UnsafeBufferPointer(start: buffer.floatChannelData![0], count: Int(buffer.frameLength))
        }
        
        //also have an AVAudioPlayer that will also play the contains of the url and is connected to the progress view to show the progress of the file playing
        //since the playerNode is playing, the audioPlayer volume is set to 0 so both aren't being played and listened to at the same time.
        audioPlay = try AVAudioPlayer(contentsOf: transferOver())
        playerNode.play()
        audioPlay.volume = 0.0
        audioPlay.play()
        
        //if the AVAudioplayer is done playing, it stops the audioEngine
        if !audioPlay.isPlaying{
            audioEngine.stop()
            playerNode.stop()
            playerNode.removeTap(onBus: 0)
        }
    }
    catch{
        print(error)
    }
    
}

//function that starts and stop the audioEngine
public func startEngine() {
    guard !audioEngine.isRunning else {
        return
    }
    
    do {
        try audioEngine.start()
    } catch { }
}

//stops the recorder
//also stops the audioEngine and resets it
func stopAndResetAudio(){
    //stop the recorder
    recorder.stop()
    audioEngine.stop()
    audioEngine.reset()
}

