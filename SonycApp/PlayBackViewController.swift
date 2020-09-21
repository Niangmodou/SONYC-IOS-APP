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
import MapKit

var audioPlay: AVAudioPlayer!
class PlayBackViewController: UIViewController, AVAudioRecorderDelegate, MFMessageComposeViewControllerDelegate{
    var feeling:String!
    var youAre:String!
    var min: String!
    var avg: String!
    var max: String!
    var locationType: String!
    var location: String!
    var noiseType: String!
    var date: String!
    var time: String!
    
    let minWordLabel = UILabel.init()
    let avgWordLabel = UILabel.init()
    let maxWordLabel = UILabel.init()
    let mapView = MKMapView.init()
    
    let warningImage = UIImageView.init()
    let mapViewReportDetails = MKMapView.init()
    let locationLabel = UILabel.init()
    let maxDecibelsLabel = UILabel.init()
    let avgDecibelsLabel = UILabel.init()
    let minDecibelsLabel = UILabel.init()
    let youFeelImage = UIImageView.init()
    let youAreImage = UIImageView.init()
    let youAreLabel = UILabel.init()
    let saveButton = UIButton.init()
    let reportButton = UIButton.init()
    let dateLabel = UILabel.init()
    let timeLabel = UILabel.init()
    let playButton = UIButton.init()
    let progressView = UIProgressView.init()
    let locationTypeLabel = UILabel.init()
    let locationTypeImage = UIImageView.init()
    let soundLevelsLabel = UILabel.init()
    let youAreWordsLabel = UILabel.init()
    let youFeelWordsLabel = UILabel.init()
    let fastForwardButton = UIButton.init()
    let rewindButton = UIButton.init()
    let recordingDetailsLabel = UILabel.init()
    let newYorkLabel = UILabel.init()
    var playing = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feeling = (newTask.value(forKey: "faceButton") as? String)
        youAre = (newTask.value(forKey: "iAm") as? String)
        min = (newTask.value(forKey: "min") as? String)
        avg = (newTask.value(forKey: "averageDec") as? String)
        max = (newTask.value(forKey: "max") as? String)
        noiseType = (newTask.value(forKey: "noiseType") as? String)
        location = (newTask.value(forKey: "reportAddress") as? String)
        date = newTask.value(forKey: "date") as? String
        time = newTask.value(forKey: "time") as? String
        
        
        recordingDetailsLabel.frame = CGRect(x: screenWidth/2 - (screenWidth/4), y: screenHeight/12, width: screenWidth/2, height: 40)
        let recordingDetailsLabelLocationX = recordingDetailsLabel.frame.origin.x + recordingDetailsLabel.frame.width
        let recordingDetailsLabelLocationY = recordingDetailsLabel.frame.origin.y + recordingDetailsLabel.frame.height
        recordingDetailsLabel.font = UIFont.systemFont(ofSize: 24)
        recordingDetailsLabel.textColor = UIColor.black
        recordingDetailsLabel.text = "Recording Details"
        self.view.addSubview(recordingDetailsLabel)
        
        locationLabel.frame = CGRect(x: recordingDetailsLabel.frame.origin.x - 75, y: recordingDetailsLabelLocationY + screenHeight/48, width: screenWidth/2, height: screenHeight/30)
        let locationLabelLocationX = locationLabel.frame.origin.x + locationLabel.frame.width
        let locationLabelLocationY = locationLabel.frame.origin.y + locationLabel.frame.height
        locationLabel.font = UIFont.systemFont(ofSize: 15)
        locationLabel.textColor = UIColor.black
        locationLabel.text = location
        self.view.addSubview(locationLabel)
        
        dateLabel.frame = CGRect(x: locationLabelLocationX + screenWidth/5, y: recordingDetailsLabelLocationY + screenHeight/48, width: screenWidth/2.5, height: screenHeight/30)
        let dateLabelLocationX = dateLabel.frame.origin.x + dateLabel.frame.width
        let dateLabelLocationY = dateLabel.frame.origin.y + dateLabel.frame.height
        dateLabel.font = UIFont.systemFont(ofSize: 15)
        dateLabel.textColor = UIColor.black
        dateLabel.text = date
        self.view.addSubview(dateLabel)
        
        newYorkLabel.frame = CGRect(x: locationLabel.frame.origin.x, y: locationLabelLocationY + screenHeight/60, width: screenWidth/2.5, height: screenHeight/30)
        let newYorkLabelLocationX = newYorkLabel.frame.origin.x + newYorkLabel.frame.width
        let newYorkLabelLocationY = newYorkLabel.frame.origin.y + newYorkLabel.frame.height
        newYorkLabel.font = UIFont.systemFont(ofSize: 15)
        newYorkLabel.textColor = UIColor.black
        newYorkLabel.text = "New York, NY, 11225"
        self.view.addSubview(newYorkLabel)
        
        timeLabel.frame = CGRect(x:  dateLabel.frame.origin.x, y:  locationLabelLocationY + screenHeight/60, width: screenWidth/2.5, height: screenHeight/30)
        let timeLabelLocationX = timeLabel.frame.origin.x + timeLabel.frame.width
        let timeLabelLocationY = timeLabel.frame.origin.y + timeLabel.frame.height
        timeLabel.font = UIFont.systemFont(ofSize: 15)
        timeLabel.textColor = UIColor.black
        timeLabel.text = time
        self.view.addSubview(timeLabel)
        
        locationTypeImage.frame = CGRect(x:newYorkLabel.frame.origin.x , y: timeLabelLocationY + screenHeight/60, width: screenWidth/9, height: screenHeight/30 )
        let locationTypeImageLocationX = locationTypeImage.frame.origin.x + locationTypeImage.frame.width
        let locationTypeImageLocationY = locationTypeImage.frame.origin.y + locationTypeImage.frame.height
        locationTypeImage.image = wordsToImage[noiseType]
        self.view.addSubview(locationTypeImage)
        
        locationTypeLabel.frame = CGRect(x: locationTypeImageLocationX + screenWidth/20, y: timeLabelLocationY + screenHeight/60, width: screenWidth/2, height: screenHeight/30 )
        let locationTypeLabelLocationX = locationTypeLabel.frame.origin.x + locationTypeLabel.frame.width
        let locationTypeLabelLocationY = locationTypeLabel.frame.origin.y + locationTypeLabel.frame.height
        locationTypeLabel.text = "This is \(newTask.value(forKey: "noiseType")as! String)"
        self.view.addSubview(locationTypeLabel)
        
        mapView.frame = CGRect(x: locationTypeImageLocationX/2, y:  locationTypeLabelLocationY + screenHeight/50, width: screenWidth - locationTypeImageLocationX, height: screenHeight/5)
        let mapViewLocationX = mapView.frame.origin.x + mapView.frame.width
        let mapViewLocationY = mapView.frame.origin.y + mapView.frame.height
        
        self.view.addSubview(mapView)
        
        minWordLabel.frame = CGRect(x: mapView.frame.origin.x + screenWidth/25, y: mapViewLocationY  + screenHeight/42, width: screenWidth/6, height: screenHeight/30)
        let minWordLabelLocationX = minWordLabel.frame.origin.x + minWordLabel.frame.width
        let minWordLabelLocationY = minWordLabel.frame.origin.y + minWordLabel.frame.height
        minWordLabel.font = UIFont.systemFont(ofSize: 15)
        minWordLabel.textColor = UIColor.black
        minWordLabel.text = "Min"
        self.view.addSubview(minWordLabel)
        
        avgWordLabel.frame = CGRect(x: minWordLabelLocationX + screenWidth/6, y: mapViewLocationY  + screenHeight/42, width: screenWidth/6, height: screenHeight/30)
        let avgWordLabelLocationX = avgWordLabel.frame.origin.x + avgWordLabel.frame.width
        let avgWordLabelLocationY = avgWordLabel.frame.origin.y + avgWordLabel.frame.height
        avgWordLabel.font = UIFont.systemFont(ofSize: 15)
        avgWordLabel.textColor = UIColor.black
        avgWordLabel.text = "Avg"
        self.view.addSubview(avgWordLabel)
        
        maxWordLabel.frame = CGRect(x: avgWordLabelLocationX + screenWidth/6, y: mapViewLocationY  + screenHeight/42, width: screenWidth/6, height: screenHeight/30)
        let maxWordLabelLocationX = maxWordLabel.frame.origin.x + maxWordLabel.frame.width
        let maxWordLabelLocationY = maxWordLabel.frame.origin.y + maxWordLabel.frame.height
        maxWordLabel.font = UIFont.systemFont(ofSize: 15)
        maxWordLabel.textColor = UIColor.black
        maxWordLabel.text = "Max"
        self.view.addSubview(maxWordLabel)
        
        minDecibelsLabel.frame = CGRect(x: minWordLabel.frame.origin.x, y: minWordLabelLocationY + screenHeight/60, width: screenWidth/6, height: screenHeight/30)
        let minDecibelsLabelLocationX = minDecibelsLabel.frame.origin.x + minDecibelsLabel.frame.width
        let minDecibelsLabelLocationY = minDecibelsLabel.frame.origin.y + minDecibelsLabel.frame.height
        minDecibelsLabel.font = UIFont.systemFont(ofSize: 15)
        minDecibelsLabel.textColor = UIColor.black
        minDecibelsLabel.text = min + " db"
        self.view.addSubview(minDecibelsLabel)
        
        avgDecibelsLabel.frame = CGRect(x: avgWordLabel.frame.origin.x, y: avgWordLabelLocationY + screenHeight/60, width: screenWidth/6, height: screenHeight/30)
        let avgDecibelsLabelLocationX = avgDecibelsLabel.frame.origin.x + avgDecibelsLabel.frame.width
        let avgDecibelsLabelLocationY = avgDecibelsLabel.frame.origin.y + avgDecibelsLabel.frame.height
        avgDecibelsLabel.font = UIFont.systemFont(ofSize: 15)
        avgDecibelsLabel.textColor = UIColor.black
        avgDecibelsLabel.text = avg + " db"
        self.view.addSubview(avgDecibelsLabel)
        
        maxDecibelsLabel.frame = CGRect(x: maxWordLabel.frame.origin.x, y: maxWordLabelLocationY + screenHeight/60, width: screenWidth/6, height: screenHeight/30)
        let maxDecibelsLabelLocationX = maxDecibelsLabel.frame.origin.x + maxDecibelsLabel.frame.width
        let maxDecibelsLabelLocationY = maxDecibelsLabel.frame.origin.y + maxDecibelsLabel.frame.height
        maxDecibelsLabel.font = UIFont.systemFont(ofSize: 15)
        maxDecibelsLabel.textColor = UIColor.black
        maxDecibelsLabel.text = max + " db"
        self.view.addSubview(maxDecibelsLabel)
        
        progressView.frame = CGRect(x: mapView.frame.origin.x, y: minDecibelsLabelLocationY + screenHeight/52, width: screenWidth - (mapView.frame.origin.x + mapView.frame.origin.x), height: screenHeight/30)
        let progressViewLocationX = progressView.frame.origin.x + progressView.frame.width
        let progressViewLocationY = progressView.frame.origin.y + progressView.frame.height
        self.view.addSubview(progressView)
        
        rewindButton.frame = CGRect(x: minDecibelsLabel.frame.origin.x, y: progressViewLocationY + screenHeight/36, width: screenWidth/14, height: screenHeight/60)
        rewindButton.setBackgroundImage(UIImage(systemName: "backward.end.fill"), for: .normal)
        let rewindButtonLocationX = rewindButton.frame.origin.x + rewindButton.frame.width
        let rewindButtonLocationY = rewindButton.frame.origin.y + rewindButton.frame.height
        rewindButton.addTarget(self, action: #selector(rewind(_:)), for: .touchUpInside)
        self.view.addSubview(rewindButton)
        
        
        playButton.frame = CGRect(x: avgDecibelsLabel.frame.origin.x, y: progressViewLocationY + screenHeight/36, width: screenWidth/14, height: screenHeight/60)
        playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        let playButtonLocationX = playButton.frame.origin.x + playButton.frame.width
        let playButtonLocationY = playButton.frame.origin.y + playButton.frame.height
        playButton.addTarget(self, action: #selector(play(button:)), for: .touchUpInside)
        self.view.addSubview(playButton)
        
        
        fastForwardButton.frame = CGRect(x: maxDecibelsLabel.frame.origin.x, y: progressViewLocationY + screenHeight/36, width: screenWidth/14, height: screenHeight/60)
        fastForwardButton.setBackgroundImage(UIImage(systemName: "forward.end.fill"), for: .normal)
        let fastForwardButtonLocationX = fastForwardButton.frame.origin.x + fastForwardButton.frame.width
        let fastForwardButtonLocationY = fastForwardButton.frame.origin.y + fastForwardButton.frame.height
        fastForwardButton.addTarget(self, action: #selector(fastForward(_:)), for: .touchUpInside)
        self.view.addSubview(fastForwardButton)
        
        warningImage.frame = CGRect(x: minDecibelsLabel.frame.origin.x, y: rewindButtonLocationY + screenHeight/36, width: screenWidth/14, height: screenHeight/50)
        let warningImageLocationX = warningImage.frame.origin.x + warningImage.frame.width
        let warningImageLocationY = warningImage.frame.origin.y + warningImage.frame.height
        self.view.addSubview(warningImage)
        
        soundLevelsLabel.frame = CGRect(x: warningImageLocationX + screenWidth/20, y: rewindButtonLocationY + screenHeight/36, width: screenWidth/2, height: screenHeight/50)
        let soundLevelsLabelLocationX = soundLevelsLabel.frame.origin.x + soundLevelsLabel.frame.width
        let soundLevelsLabelLocationY = soundLevelsLabel.frame.origin.y + soundLevelsLabel.frame.height
        self.view.addSubview(soundLevelsLabel)
        
        youAreWordsLabel.frame = CGRect(x: warningImage.frame.origin.x, y: warningImageLocationY + screenHeight/80, width:  screenWidth/6, height: screenHeight/50)
        let youAreWordsLabelLocationX = youAreWordsLabel.frame.origin.x + youAreWordsLabel.frame.width
        let youAreWordsLabelLocationY = youAreWordsLabel.frame.origin.y + youAreWordsLabel.frame.height
        youAreWordsLabel.text = "You are"
        self.view.addSubview(youAreWordsLabel)
        
        youFeelWordsLabel.frame = CGRect(x: youAreWordsLabelLocationX + screenWidth/2.5, y: warningImageLocationY + screenHeight/80, width: screenWidth/6, height: screenHeight/50)
        let youFeelWordsLabelLocationX = youFeelWordsLabel.frame.origin.x + youFeelWordsLabel.frame.width
        let youFeelWordsLabelLocationY = youFeelWordsLabel.frame.origin.y + youFeelWordsLabel.frame.height
        youFeelWordsLabel.text = "You feel"
        self.view.addSubview(youFeelWordsLabel)
        
        youAreImage.frame = CGRect(x: youAreWordsLabel.frame.origin.x, y: youAreWordsLabelLocationY + screenHeight/36, width: screenWidth/12, height: screenHeight/40)
        let youAreImageLocationX = youAreImage.frame.origin.x + youAreImage.frame.width
        let youAreImageLocationY = youAreImage.frame.origin.y + youAreImage.frame.height
        youAreImage.image = wordsToImage[youAre]
        self.view.addSubview(youAreImage)
        
        youAreLabel.frame = CGRect(x: youAreImageLocationX + screenWidth/20, y: youAreWordsLabelLocationY + screenHeight/36, width: screenWidth/4, height: screenHeight/40)
        let youAreLabelLocationX = youAreLabel.frame.origin.x + youAreLabel.frame.width
        let youAreLabelLocationY = youAreLabel.frame.origin.y + youAreLabel.frame.height
        youAreLabel.text = youAre
        self.view.addSubview(youAreLabel)
        
        youFeelImage.frame = CGRect(x: youFeelWordsLabel.frame.origin.x, y: youFeelWordsLabelLocationY + screenHeight/36, width: screenWidth/12, height: screenHeight/40)
        let youFeelImageLocationX = youFeelImage.frame.origin.x + youFeelImage.frame.width
        let youFeelImageLocationY = youFeelImage.frame.origin.y + youFeelImage.frame.height
        youFeelImage.image = wordsToImage[feeling]
        self.view.addSubview(youFeelImage)
        
        saveButton.frame = CGRect(x: youAreImage.frame.origin.x, y: youAreImageLocationY + screenHeight/30, width: screenWidth/3, height: screenHeight/20)
        let saveButtonLocationX = saveButton.frame.origin.x + saveButton.frame.width
        let saveButtonLocationY = saveButton.frame.origin.y + saveButton.frame.height
        saveButton.setTitleColor(UIColor.button(), for: .normal)
        saveButton.backgroundColor = UIColor.white
        addingBorder(button: saveButton)
        curvingButton(button: saveButton)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveOnlyAction(_:)), for: .touchUpInside)
        self.view.addSubview(saveButton)
        
        reportButton.frame = CGRect(x: saveButtonLocationX + screenWidth/10, y: youFeelImageLocationY + screenHeight/30, width: screenWidth/3, height: screenHeight/20)
        let reportButtonLocationX = reportButton.frame.origin.x + reportButton.frame.width
        let reportButtonLocationY = reportButton.frame.origin.y + reportButton.frame.height
        reportButton.backgroundColor = UIColor.button()
        reportButton.setTitleColor(UIColor.white, for: .normal)
        addingBorder(button: reportButton)
        curvingButton(button: reportButton)
        reportButton.setTitle("Report", for: .normal)
        reportButton.addTarget(self, action: #selector(sendText(_:)), for: .touchUpInside)
        self.view.addSubview(reportButton)
        
        prepareToPlayFile()
        
        let latitude = (newTask.value(forKey: "reportLatitude") as! NSString).floatValue
        let longitude = (newTask.value(forKey: "reportLongitude") as! NSString).floatValue
        
        print(latitude, longitude)
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        centerMapOnLocation(location, mapView: mapView)
        plotAnnotation(title: "report",
                       latitude: CLLocationDegrees(latitude),
                       longitude: CLLocationDegrees(longitude))
        
    }
    
    func centerMapOnLocation(_ location: CLLocationCoordinate2D, mapView: MKMapView)  {
        let regionRadius: CLLocationDistance = 5000
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: regionRadius * 0.0625,
                                                  longitudinalMeters: regionRadius * 0.0625)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //Function to plot annotations on the map
    func plotAnnotation(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
        let loc = MKPointAnnotation()
        
        loc.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        loc.title = title
        
        mapView.addAnnotation(loc)
    }
    
    @objc func saveOnlyAction(_ sender: Any) {
        if playing{
            audioPlay.stop()
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "recordingsSaved") ; // recordingSaved is the storyboard ID
        self.present(vc, animated: true, completion: nil);
        
    }
    //have to connect the fastFoward and the rewind to the playerNode
    @objc func fastForward(_ sender: Any) {
        var time: TimeInterval = audioPlay.currentTime
        time += 1.0 // Go forward by 1 second
        audioPlay.currentTime = time
    }
    
    
    @objc func rewind(_ sender: Any) {
        var time: TimeInterval = audioPlay.currentTime
        time -= 1.0 // Go back by 1 second
        audioPlay.currentTime = time
    }
    
    //plays the file and shows the progress on the progress view.
    @objc func play(button: UIButton) {
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
//            pauses the audio
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
    @objc func sendText(_ sender: Any) {
        if playing{
            audioPlay.stop()
        }
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "recordingsSaved") ; // recordingsSaved is the storyboard ID
        self.present(vc, animated: true, completion: nil);
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

