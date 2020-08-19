//
//  PlayBackViewController.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 7/23/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//
import UIKit
import CoreData
import AVFoundation
import AudioToolbox
import MessageUI

var audioPlay: AVAudioPlayer!
class PlayBackViewController: UIViewController, AVAudioRecorderDelegate, MFMessageComposeViewControllerDelegate{
    var feeling:String!
    var youAre:String!
    var min: String!
    var avg: String!
    var max: String!
    var locationType: String!
    
    
    @IBOutlet weak var locationLabel: UILabel!
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
    
    @IBOutlet weak var locationTypeLabel: UILabel!
    @IBOutlet weak var locationTypeImage: UIImageView!
    @IBOutlet weak var gaugeView: GaugeView!
    var playing = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addingBorder(button: saveOnlyButton)
        saveOnlyButton.layer.borderColor = UIColor.faceSelected().cgColor
        curvingButton(button: saveOnlyButton)
        curvingButton(button: reportButton)
        feeling = (newTask.value(forKey: "faceButton") as! String)
        youAre = (newTask.value(forKey: "iAm") as! String)
        min = (newTask.value(forKey: "min") as! String)
        avg = (newTask.value(forKey: "averageDec") as! String)
        max = (newTask.value(forKey: "max") as! String)
        locationType = (newTask.value(forKey: "locationType") as! String)
        
        //information that will be stored in the recording details of the card
        //images and label for the file.
        locationTypeImage.image = wordsToImage[locationType]
        youFeelImage.image = wordsToImage[feeling]
        youAreImage.image = wordsToImage[youAre]
        youAreLabel.text = newTask.value(forKey: "iAm") as? String
        dateLabel.text = newTask.value(forKey: "date") as? String
        timeLabel.text = newTask.value(forKey: "time") as? String
        locationTypeLabel.text = newTask.value(forKey: "locationType") as? String
        minDecibelsLabel.text = min + " db"
        avgDecibelsLabel.text = avg + " db"
        maxDecibelsLabel.text = max + " db"
        prepareToPlayFile()
        
    }
    
    @IBAction func saveOnlyAction(_ sender: Any) {
        if playing{
            audioPlay.stop()
        }
    }
    //have to connect the fastFoward and the rewind to the playerNode
    @IBAction func fastForward(_ sender: Any) {
        var time: TimeInterval = audioPlay.currentTime
        time += 1.0 // Go forward by 1 second
        audioPlay.currentTime = time
    }
    
    
    @IBAction func rewind(_ sender: Any) {
        var time: TimeInterval = audioPlay.currentTime
        time -= 1.0 // Go back by 1 second
        audioPlay.currentTime = time
    }
    
    //plays the file and shows the progress on the progress view.
    @IBAction func play(button: UIButton) {
        button.isSelected.toggle()
        if (button.isSelected){
            //playing the file
            playFile()
            //progressview progress
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
            progressView.setProgress(Float(audioPlay.currentTime/audioPlay.duration), animated: false)
            button.setImage(UIImage(named: "pause.fill"), for: [.highlighted, .selected])
            playing = true
        }
        else{
            //pauses the audio
            audioPlay.pause()
            button.setImage(UIImage(systemName: "play.fill"), for: .normal)
            playing = false
        }
        playing = false
    }
    
    //updates the progress view while the audiofile is playing
    @objc func updateAudioProgressView(){
        //while the audioPlay is playing
        if audioPlay.isPlaying
        {
            //updates the progressview based on the audioPlay
            progressView.setProgress(Float(audioPlay.currentTime/audioPlay.duration), animated: true)
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
    
}

//converts the url of where the file is to an AVAudioFile format inorder to connect it to the playerNode.
func readableAudioFileFrom(url: URL) -> AVAudioFile {
    var audioFile: AVAudioFile!
    do {
        try audioFile = AVAudioFile(forReading: url)
    } catch { }
    return audioFile
}

//prepare to play the audio file
func prepareToPlayFile(){
    do{
        let name = newTask.value(forKey: "path")
        let filename = getDirectory().appendingPathComponent(name as! String)
        
        audioPlay = try AVAudioPlayer(contentsOf: filename)
        audioPlay.prepareToPlay()
    }
    catch{
        print(error)
    }
}

//plays the file
func playFile(){
    audioPlay.play()
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

