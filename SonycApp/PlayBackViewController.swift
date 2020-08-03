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

class PlayBackViewController: UIViewController, AVAudioRecorderDelegate{
    
    @IBOutlet weak var saveOnlyButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    var meterTimer2: Timer!
    @IBOutlet weak var gaugeView: GaugeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = String(gaugeView.counter) + "db"
        addingBorder(button: saveOnlyButton)
        saveOnlyButton.layer.borderColor = UIColor.faceSelected().cgColor
        curvingButton(button: saveOnlyButton)
        curvingButton(button: reportButton)
    }
    
    @objc func keepDoing(){
      
    }
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
    
    @IBAction func play(button: UIButton) {
        button.isSelected.toggle()
        if button.isSelected{
            do{
                //timer for updating the progressview
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
                //setting progress of the progressView
                progressView.setProgress(Float(audioPlayer.currentTime/audioPlayer.duration), animated: false)
                meterTimer2 = Timer.scheduledTimer(timeInterval:0.1, target:self, selector:#selector(self.keepDoing), userInfo:nil, repeats: true)
                
            }
            catch{
                print(error)
            }
        }
        else{
            button.setImage(UIImage(systemName: "pause.fill"), for: [.highlighted, .selected])
            audioPlayer.pause()
        }
    }
    
    
    @objc func updateAudioProgressView(){
        if audioPlayer.isPlaying
        {
            progressView.setProgress(Float(audioPlayer.currentTime/audioPlayer.duration), animated: true)
        }
    }
    
}
