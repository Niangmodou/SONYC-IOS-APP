//
//  PlayBackFromRecordings.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 8/16/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//


import UIKit
import CoreData
import AVFoundation
import AudioToolbox

class PlayBackFromRecordings: UIViewController, AVAudioRecorderDelegate{
    var feeling:String!
    var youAre:String!
    var min: String!
    var avg: String!
    var max: String!
    var locationType: String!
    var path: String!
    
    
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
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var locationTypeLabel: UILabel!
    @IBOutlet weak var locationTypeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feeling = (audioCards[positionRecording].value(forKey: "faceButton") as! String)
        youAre = (audioCards[positionRecording].value(forKey: "iAm") as! String)
        min = (audioCards[positionRecording].value(forKey: "min") as! String)
        avg = (audioCards[positionRecording].value(forKey: "averageDec") as! String)
        max = (audioCards[positionRecording].value(forKey: "max") as! String)
        locationType = (audioCards[positionRecording].value(forKey: "locationType") as! String)
        path = (audioCards[positionRecording].value(forKey: "path") as! String)
        
        
        //information that will be stored in the recording details of the card
        //images and label for the file.
        locationTypeImage.image = wordsToImage[locationType]
        youFeelImage.image = wordsToImage[feeling]
        youAreImage.image = wordsToImage[youAre]
        youAreLabel.text = (audioCards[positionRecording].value(forKey: "iAm") as! String)
        dateLabel.text = (audioCards[positionRecording].value(forKey: "date") as! String)
        timeLabel.text = (audioCards[positionRecording].value(forKey: "time") as! String)
        locationTypeLabel.text = (audioCards[positionRecording].value(forKey: "locationType") as! String)
        minDecibelsLabel.text = min + " db"
        avgDecibelsLabel.text = avg + " db"
        maxDecibelsLabel.text = max + " db"
        prepareToPlayFileBack()
        
    }
    
    //fast forward the audioPlayer
    @IBAction func fastForward(_ sender: Any) {
        var time: TimeInterval = audioPlay.currentTime
        time += 1.0 // Go forward by 1 second
        audioPlay.currentTime = time
    }
    
    //rewind the audioPlayer
    @IBAction func rewind(_ sender: Any) {
        var time: TimeInterval = audioPlay.currentTime
        time -= 1.0 // Go back by 1 second
        audioPlay.currentTime = time
    }
    
    //plays the file and shows the progress on the progress view.
    @IBAction func play(button: UIButton) {
        button.isSelected.toggle()
        if (button.isSelected){
            //play the file
            playFileBack()
            //the progressview
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
            progressView.setProgress(Float(audioPlay.currentTime/audioPlay.duration), animated: false)
            button.setImage(UIImage(named: "pause.fill"), for: [.highlighted, .selected])
        }
        else{
            //pausing the audio
            audioPlay.pause()
            button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    //updates the progress view while the audiofile is playing
    @objc func updateAudioProgressView(){
        //if the audio is playing
        if audioPlay.isPlaying
        {
            //update the progress view
            progressView.setProgress(Float(audioPlay.currentTime/audioPlay.duration), animated: true)
        }
    }
    
}

//prepare to play the audio file
func prepareToPlayFileBack(){
    //get the name of the file that was stored
    let name = (audioCards[positionRecording].value(forKey: "path"))
    //creates the filename for the file
    let filename = getDirectory().appendingPathComponent(name as! String)
    do{
        //plays the audio file
        audioPlay = try AVAudioPlayer(contentsOf: filename)
        audioPlay.prepareToPlay()
    }
    catch{
        print(error)
    }
}

//plays the audio file back
func playFileBack(){
    audioPlay.play()
}
