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
    var path: String!
    var location: String!
    let progressView = UIProgressView.init()
    @IBOutlet weak var playButton: UIButton!
    let youFeelImage = UIImageView.init()
    let youAreImage = UIImageView.init()
    let maxDecibelsLabel = UILabel.init()
    let avgDecibelsLabel = UILabel.init()
    let minDecibelsLabel = UILabel.init()
    let locationLabel = UILabel.init()
    let dateLabel = UILabel.init()
    let youAreLabel = UILabel.init()
    let timeLabel = UILabel.init()
    let locationTypeLabel = UILabel.init()
    let locationTypeImage = UIImageView.init()
    let titleRecordingDetails = UILabel.init()
    let minLabel = UILabel.init()
    let maxLabel = UILabel.init()
    let avgLabel = UILabel.init()
    let fastForwardButton = UIButton.init()
    let rewindButton = UIButton.init()
    let locationWordLabel = UILabel.init()
    let locationTypeWordLabel = UILabel.init()
    let youFeelWordLabel = UILabel.init()
    let youAreWordLabel = UILabel.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        feeling = (audioCards[positionRecording].value(forKey: "faceButton") as? String)
        youAre = (audioCards[positionRecording].value(forKey: "iAm") as? String)
        min = (audioCards[positionRecording].value(forKey: "min") as? String)
        avg = (audioCards[positionRecording].value(forKey: "averageDec") as? String)
        max = (audioCards[positionRecording].value(forKey: "max") as? String)
        path = (audioCards[positionRecording].value(forKey: "path") as? String)
        location = (audioCards[positionRecording].value(forKey: "reportAddress") as? String)
        
        titleRecordingDetails.frame = CGRect(x: screenWidth/2 - (screenWidth/4.2), y: screenHeight/12, width: screenWidth/2, height: 40)
        let titleRecordingDetailsLocationY = labelYPosition(label: titleRecordingDetails)
        titleRecordingDetails.font = UIFont.systemFont(ofSize: 24)
        titleRecordingDetails.textColor = UIColor.black
        titleRecordingDetails.text = "Recording Details"
        self.view.addSubview(titleRecordingDetails)
        
        timeLabel.frame = CGRect(x: titleRecordingDetails.frame.origin.x - (screenWidth/7), y: titleRecordingDetailsLocationY + screenHeight/36, width: screenWidth/4, height: 40)
        timeLabel.text = (audioCards[positionRecording].value(forKey: "time") as! String)
        timeLabel.font = UIFont.systemFont(ofSize: 17)
        let timeLabellLocationX = labelXPosition(label: timeLabel)
        let timeLabellLocationY = labelYPosition(label: timeLabel)
        self.view.addSubview(timeLabel)
        dateLabel.frame = CGRect(x: timeLabellLocationX + (screenWidth/2.5), y: titleRecordingDetailsLocationY + screenHeight/36, width: screenWidth/4, height: 40)
        dateLabel.text = (audioCards[positionRecording].value(forKey: "date") as! String)
        dateLabel.font = UIFont.systemFont(ofSize: 17)
        self.view.addSubview(dateLabel)
        
        minLabel.frame = CGRect(x: timeLabel.frame.origin.x, y: timeLabellLocationY + screenHeight/24 , width: screenWidth/6, height: 40)
        minLabel.text = "Min"
        minLabel.font = UIFont.systemFont(ofSize: 17)
        let minLabelLocationX = labelXPosition(label: minLabel)
        let minLabelLocationY = labelYPosition(label: minLabel)
        avgLabel.frame = CGRect(x: minLabelLocationX + screenWidth/6, y: timeLabellLocationY + screenHeight/24, width: screenWidth/6, height: 40)
        avgLabel.text = "Avg"
        avgLabel.font = UIFont.systemFont(ofSize: 17)
        let avgLabelLocationX = labelXPosition(label: avgLabel)
        let avgLabelLocationY = labelYPosition(label: avgLabel)
        maxLabel.frame = CGRect(x: avgLabelLocationX + screenWidth/6, y: timeLabellLocationY + screenHeight/24, width: screenWidth/6, height: 40)
        maxLabel.text = "Max"
        maxLabel.font = UIFont.systemFont(ofSize: 17)
        let maxLabelLocationY = labelYPosition(label: maxLabel)
        self.view.addSubview(minLabel)
        self.view.addSubview(avgLabel)
        self.view.addSubview(maxLabel)
        minDecibelsLabel.frame = CGRect(x: minLabel.frame.origin.x - screenWidth/40, y: minLabelLocationY + screenHeight/60, width: screenWidth/5, height: 40)
        minDecibelsLabel.text = min + " db"
        let minDecibelsLabelLocationY = labelYPosition(label: minDecibelsLabel)
        avgDecibelsLabel.frame = CGRect(x: avgLabel.frame.origin.x - screenWidth/40, y: avgLabelLocationY + screenHeight/60, width: screenWidth/5, height: 40)
        avgDecibelsLabel.text = avg + " db"
        maxDecibelsLabel.frame = CGRect(x: maxLabel.frame.origin.x - screenWidth/40, y: maxLabelLocationY + screenHeight/60, width: screenWidth/5, height: 40)
        maxDecibelsLabel.text = max + " db"
        self.view.addSubview(minDecibelsLabel)
        self.view.addSubview(avgDecibelsLabel)
        self.view.addSubview(maxDecibelsLabel)
        
        progressView.frame = CGRect(x: minLabel.frame.origin.x - (screenWidth/100) , y: minDecibelsLabelLocationY + screenHeight/20, width: screenWidth - ( minLabelLocationX - (screenWidth/18)) , height: 40)
        let progressViewLLocationY = progressView.frame.origin.y + progressView.frame.height
        self.view.addSubview(progressView)
        
        rewindButton.frame = CGRect(x: minDecibelsLabel.frame.origin.x + screenWidth/20, y: progressViewLLocationY + screenHeight/25, width: screenWidth/16, height: screenHeight/60)
        rewindButton.setBackgroundImage(UIImage(systemName: "backward.end.fill"), for: .normal)
        playButton.frame = CGRect(x: avgDecibelsLabel.frame.origin.x , y: progressViewLLocationY + screenHeight/25, width: screenWidth/16, height: screenHeight/60)
        let playButtonLocationY = buttonYPosition(button: playButton)
        fastForwardButton.frame = CGRect(x: maxDecibelsLabel.frame.origin.x , y: progressViewLLocationY + screenHeight/25, width: screenWidth/16, height: screenHeight/60)
        fastForwardButton.setBackgroundImage(UIImage(systemName: "forward.end.fill"), for: .normal)
        
        rewindButton.addTarget(self, action: #selector(rewind(_:)), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
        fastForwardButton.addTarget(self, action: #selector(fastForward(_:)), for: .touchUpInside)
        self.view.addSubview(rewindButton)
        self.view.addSubview(playButton)
        self.view.addSubview(fastForwardButton)
        
        locationWordLabel.frame = CGRect(x: progressView.frame.origin.x, y:  playButtonLocationY + screenHeight/20, width: screenWidth/3, height: 40)
        locationWordLabel.text = "Noise Location"
        locationWordLabel.font = UIFont.systemFont(ofSize: 17)
        let locationWordLabelLocationX = labelXPosition(label: locationWordLabel)
        let locationWordLabelLocationY = labelYPosition(label: locationWordLabel)
        
        locationTypeWordLabel.frame = CGRect(x: locationWordLabelLocationX + screenWidth/6, y:  playButtonLocationY + screenHeight/20 , width: screenWidth/3, height: 40)
        locationTypeWordLabel.text = "Location type"
        locationTypeWordLabel.font = UIFont.systemFont(ofSize: 17)
        self.view.addSubview(locationWordLabel)
        self.view.addSubview(locationTypeWordLabel)
        
        locationLabel.frame = CGRect(x: locationWordLabel.frame.origin.x, y:  locationWordLabelLocationY + screenHeight/100 , width: screenWidth/2, height: 40)
        locationLabel.text = location
        locationLabel.font = UIFont.systemFont(ofSize: 15)
        locationLabel.sizeToFit()
        let locationLabelLocationY = labelYPosition(label: locationLabel)
        
        locationTypeImage.frame = CGRect(x: locationTypeWordLabel.frame.origin.x, y: locationWordLabelLocationY + screenHeight/100, width: screenWidth/10, height: 30)
        locationTypeImage.image = wordsToImage[" Building"]
        let locationTypeImageLocationX = locationTypeImage.frame.origin.x + locationTypeImage.frame.width
        
        locationTypeLabel.frame = CGRect(x: locationTypeImageLocationX + screenWidth/40 , y:  locationWordLabelLocationY + screenHeight/100 , width: screenWidth/5, height: 40)
        locationTypeLabel.text = "Test Type"
        locationTypeLabel.font = UIFont.systemFont(ofSize: 17)
        let locationTypeLabelLocationY = labelYPosition(label: locationTypeLabel)
        
        self.view.addSubview(locationLabel)
        self.view.addSubview(locationTypeImage)
        self.view.addSubview(locationTypeLabel)
        
        youAreWordLabel.frame = CGRect(x: locationWordLabel.frame.origin.x, y: locationLabelLocationY + screenHeight/40, width: screenWidth/3, height: 40)
        youAreWordLabel.text = "You are"
        youAreWordLabel.font = UIFont.systemFont(ofSize: 17)
        let youAreWordLabelLocationY = labelYPosition(label: youAreWordLabel)
        youFeelWordLabel.frame = CGRect(x: locationTypeWordLabel.frame.origin.x, y: locationTypeLabelLocationY + screenHeight/40, width: screenWidth/3, height: 40)
        youFeelWordLabel.text = "You feel"
        youFeelWordLabel.font = UIFont.systemFont(ofSize: 17)
        let youFeelWordLabelLocationY = labelYPosition(label: youFeelWordLabel)
        self.view.addSubview(youAreWordLabel)
        self.view.addSubview(youFeelWordLabel)
        
        youAreLabel.frame = CGRect(x: youAreWordLabel.frame.origin.x, y: youAreWordLabelLocationY + screenHeight/100, width: screenWidth/6, height: 40)
        youAreLabel.text = (audioCards[positionRecording].value(forKey: "iAm") as! String)
        youAreLabel.font = UIFont.systemFont(ofSize: 15)
        let youAreLabelLocationX = labelXPosition(label: youAreLabel)
        youAreImage.frame = CGRect(x: youAreLabelLocationX, y: youAreWordLabelLocationY + screenHeight/100, width: screenWidth/10, height: 40)
        youAreImage.image = wordsToImage[youAre]
        youFeelImage.frame = CGRect(x: youFeelWordLabel.frame.origin.x, y: youFeelWordLabelLocationY + screenHeight/100, width: screenWidth/10, height: 40)
        youFeelImage.image = wordsToImage[feeling]
        
        self.view.addSubview(youAreLabel)
        self.view.addSubview(youFeelImage)
        self.view.addSubview(youAreImage)
        
        prepareToPlayFileBack()
        print(newTask.value(forKey: "reportAddress") as Any, "playbackfromreocrding")
    }
    
    //    fast forward the audioPlayer
    @objc func fastForward(_ sender: Any) {
        var time: TimeInterval = audioPlay.currentTime
        time += 1.0 // Go forward by 1 second
        audioPlay.currentTime = time
    }
    
    //rewind the audioPlayer
    @objc func rewind(_ sender: Any) {
        var time: TimeInterval = audioPlay.currentTime
        time -= 1.0 // Go back by 1 second
        audioPlay.currentTime = time
    }
    
    //plays the file and shows the progress on the progress view.
    @objc func play(_ button: UIButton) {
        button.isSelected.toggle()
        button.setImage(UIImage(named: "pause.fill"), for: [.highlighted, .selected])
        if (button.isSelected){
            //play the file
            playFileBack()
            //the progressview
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
            progressView.setProgress(Float(audioPlay.currentTime/audioPlay.duration), animated: false)
//            button.setImage(UIImage(named: "pause.fill"), for: [.highlighted, .selected])
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

////prepare to play the audio file
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
