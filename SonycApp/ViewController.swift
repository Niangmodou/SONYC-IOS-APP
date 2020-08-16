//
//  ViewController.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 7/23/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVFoundation
import SideMenu

var recordings = 0
var meterTimer: Timer!
var meterTimer2: Timer!
var recordingSession: AVAudioSession!
var audioRecorder:AVAudioRecorder!
var audioPlayer: AVAudioPlayer!
var decibelsArray:[Float] = [];
//let appDelegate = UIApplication.shared.delegate as! AppDelegate
class ViewController: UIViewController, AVAudioRecorderDelegate{
    //podfile for slide out menu
    var menu: SideMenuNavigationController?
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var decibelsLabel: UILabel!
    
    
    @IBOutlet weak var gaugeView: GaugeView!
    @IBOutlet weak var counterLabel: UILabel!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //populates the dictionary of images and respected keywords
        fillDict()
        //for the side menu
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
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
    }
    
    //button for the hamburger that makes the slide out happen
    @IBAction func didTapHamburger(){
        present(menu!, animated: true)
    }
    
    //record starts the audioEngine and the recorder and presents the new page
    @IBAction func record(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "secondScreen") ; // MySecondSecreen is the storyboard ID
        self.present(vc, animated: true, completion: nil);
        
    }
}
