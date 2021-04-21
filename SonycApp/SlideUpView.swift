//
//  SlideUpView.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 7/23/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//
import UIKit
import CoreData
import AVFoundation

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
//core data details
let entity = NSEntityDescription.entity(forEntityName: "Audio", in: context)
let newTask = NSManagedObject(entity: entity!, insertInto: context)
let constructionButton = UIButton.init(type: .custom)
let nightLifeButton = UIButton.init(type: .custom)
let musicButton = UIButton.init(type: .custom)
let deliveryButton = UIButton.init(type: .custom)
let garbageButton = UIButton.init(type: .custom)
let noiseTypeOtherButton = UIButton.init(type: .custom)
let homeButton = UIButton.init(type: .custom)
let elsewhereButton = UIButton.init(type: .custom)
let sleepingButton = UIButton.init(type: .custom)
let parentingButton = UIButton.init(type: .custom)
let workingButton = UIButton.init(type: .custom)
let othersButton = UIButton.init(type: .custom)
let restingButton = UIButton.init(type: .custom)
let walkingButton = UIButton.init(type: .custom)
let mehFaceButton = UIButton.init(type: .custom)
let dizzyFaceButton = UIButton.init(type: .custom)
let annoyedFaceButton = UIButton.init(type: .custom)
let angryFaceButton = UIButton.init(type: .custom)
let frustratedFaceButton = UIButton.init(type: .custom)
let happyFaceButton = UIButton.init(type: .custom)
let identifyNoiseSourceButton = UIButton.init(type: .custom)
var screenWidth = UIScreen.main.fixedCoordinateSpace.bounds.width
var screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.height


class SlideUpView: UIViewController {
    let locationButtonArray: [UIButton]! = [homeButton, elsewhereButton]
    let iAmButtonsArray: [UIButton]! = [sleepingButton, parentingButton, workingButton,othersButton,restingButton,walkingButton]
    let faceButtonArray: [UIButton]! = [mehFaceButton,dizzyFaceButton,annoyedFaceButton,angryFaceButton,frustratedFaceButton,happyFaceButton]
    let noiseTypeArray: [UIButton]! = [constructionButton, nightLifeButton, musicButton, deliveryButton,garbageButton,noiseTypeOtherButton]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        let noiseTypeLabel = UILabel.init()
        noiseTypeLabel.frame = CGRect(x: 15, y: screenHeight/20, width: screenWidth/3.5, height: 25)
        let noiseTypeLabelLocationY = labelYPosition(label: noiseTypeLabel)
        noiseTypeLabel.text = "Noise Type"
        noiseTypeLabel.textColor = UIColor.black
        self.view.addSubview(noiseTypeLabel)
        
        constructionButton.frame = CGRect(x: 15, y: noiseTypeLabelLocationY + screenHeight/20, width: screenWidth/3.5, height: screenHeight/25)
        let constructionButtonLocationX = buttonXPosition(button: constructionButton)
        let constructionButtonLocationY = buttonYPosition(button: constructionButton)
        constructionButton.setTitle(" Construction", for: .normal)
        constructionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        constructionButton.setTitleColor(UIColor.black, for: .normal)
        constructionButton.setImage(UIImage(named: "Logo_construction.png"), for: .normal)
        constructionButton.layer.borderWidth = 2.0
        constructionButton.layer.cornerRadius = 10
        constructionButton.layer.borderColor = UIColor.black.cgColor
        constructionButton.addTarget(self, action: #selector(noiseTypeButtonsSelect(_:)), for: .touchUpInside)
        self.view.addSubview(constructionButton)
        
        
        nightLifeButton.frame = CGRect(x: constructionButtonLocationX + screenWidth/24, y: noiseTypeLabelLocationY + screenHeight/20, width: screenWidth/3.5, height: screenHeight/25)
        let nightLifeButtonLocationX = buttonXPosition(button: nightLifeButton)
        let nightLifeButtonLocationY = buttonYPosition(button: nightLifeButton)
        nightLifeButton.setTitle(" NightLife", for: .normal)
        nightLifeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        nightLifeButton.setTitleColor(UIColor.black, for: .normal)
        nightLifeButton.setImage(UIImage(named: "Logo_nightlife.png"), for: .normal)
        nightLifeButton.layer.borderWidth = 2.0
        nightLifeButton.layer.cornerRadius = 10
        nightLifeButton.layer.borderColor = UIColor.black.cgColor
        nightLifeButton.addTarget(self, action: #selector(noiseTypeButtonsSelect(_:)), for: .touchUpInside)
        self.view.addSubview(nightLifeButton)
        
        
        musicButton.frame = CGRect(x: nightLifeButtonLocationX + screenWidth/24, y: noiseTypeLabelLocationY + screenHeight/20, width: screenWidth/3.5, height: screenHeight/25)
        let musicButtonLocationY = buttonYPosition(button: musicButton)
        musicButton.setTitle(" Music", for: .normal)
        musicButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        musicButton.setTitleColor(UIColor.black, for: .normal)
        musicButton.setImage(UIImage(named: "Logo_music.png"), for: .normal)
        musicButton.layer.borderWidth = 2.0
        musicButton.layer.cornerRadius = 10
        musicButton.layer.borderColor = UIColor.black.cgColor
        musicButton.addTarget(self, action: #selector(noiseTypeButtonsSelect(_:)), for: .touchUpInside)
        self.view.addSubview(musicButton)
        
        deliveryButton.frame = CGRect(x: 15, y: constructionButtonLocationY + screenHeight/30, width: screenWidth/3.5, height: screenHeight/25)
        let deliveryButtonLocationY = buttonYPosition(button: deliveryButton)
        deliveryButton.setTitle(" Delivery", for: .normal)
        deliveryButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        deliveryButton.setTitleColor(UIColor.black, for: .normal)
        deliveryButton.setImage(UIImage(named: "Logo_truck.png"), for: .normal)
        deliveryButton.layer.borderWidth = 2.0
        deliveryButton.layer.cornerRadius = 10
        deliveryButton.layer.borderColor = UIColor.black.cgColor
        deliveryButton.addTarget(self, action: #selector(noiseTypeButtonsSelect(_:)), for: .touchUpInside)
        self.view.addSubview(deliveryButton)
        
        garbageButton.frame = CGRect(x: nightLifeButton.frame.origin.x, y: nightLifeButtonLocationY + screenHeight/30, width: screenWidth/3.5, height: screenHeight/25)
        garbageButton.setTitle(" Garbage", for: .normal)
        garbageButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        garbageButton.setTitleColor(UIColor.black, for: .normal)
        garbageButton.setImage(UIImage(named: "Logo_garbage.png"), for: .normal)
        garbageButton.layer.borderWidth = 2.0
        garbageButton.layer.cornerRadius = 10
        garbageButton.layer.borderColor = UIColor.black.cgColor
        garbageButton.addTarget(self, action: #selector(noiseTypeButtonsSelect(_:)), for: .touchUpInside)
        self.view.addSubview(garbageButton)
        
        
        noiseTypeOtherButton.frame = CGRect(x: musicButton.frame.origin.x, y: musicButtonLocationY + screenHeight/30, width: screenWidth/3.5, height: screenHeight/25)
        noiseTypeOtherButton.setTitle("Other", for: .normal)
        noiseTypeOtherButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        noiseTypeOtherButton.setTitleColor(UIColor.black, for: .normal)
        noiseTypeOtherButton.layer.borderWidth = 2.0
        noiseTypeOtherButton.layer.cornerRadius = 10
        noiseTypeOtherButton.layer.borderColor = UIColor.black.cgColor
        noiseTypeOtherButton.addTarget(self, action: #selector(noiseTypeButtonsSelect(_:)), for: .touchUpInside)
        self.view.addSubview(noiseTypeOtherButton)
        
        let locationLabel = UILabel.init()
        locationLabel.frame = CGRect(x: 15, y: deliveryButtonLocationY + screenHeight/30, width: screenWidth/3, height: screenHeight/20)
        let locationLabelLocationY = labelYPosition(label: locationLabel)
        locationLabel.text = "Location"
        locationLabel.textColor = UIColor.black
        self.view.addSubview(locationLabel)
        
        homeButton.frame = CGRect(x: 15, y: locationLabelLocationY + screenHeight/36, width: screenWidth/3, height: screenHeight/25)
        let homeButtonLocationX = buttonXPosition(button: homeButton)
        let homeButtonLocationY = buttonYPosition(button: homeButton)
        homeButton.setTitle(" Home", for: .normal)
        homeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        homeButton.setTitleColor(UIColor.black, for: .normal)
        homeButton.setImage(UIImage(named: "Icon_Indoor.png"), for: .normal)
        homeButton.layer.borderWidth = 2.0
        homeButton.layer.cornerRadius = 10
        homeButton.layer.borderColor = UIColor.black.cgColor
        homeButton.addTarget(self, action: #selector(selectOrDeselect(_:)), for: .touchUpInside)
        self.view.addSubview(homeButton)
        
        elsewhereButton.frame = CGRect(x: homeButtonLocationX + screenWidth/4, y: locationLabelLocationY + screenHeight/36, width: screenWidth/3, height: screenHeight/25)
        elsewhereButton.setTitle(" Elsewhere", for: .normal)
        elsewhereButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        elsewhereButton.setTitleColor(UIColor.black, for: .normal)
        elsewhereButton.setImage(UIImage(named: "Icon_Outdoor.png"), for: .normal)
        elsewhereButton.layer.borderWidth = 2.0
        elsewhereButton.layer.cornerRadius = 10
        elsewhereButton.layer.borderColor = UIColor.black.cgColor
        elsewhereButton.addTarget(self, action: #selector(selectOrDeselect(_:)), for: .touchUpInside)
        self.view.addSubview(elsewhereButton)
        
        let iAmLabel = UILabel.init()
        iAmLabel.frame = CGRect(x: 15, y: homeButtonLocationY + screenHeight/30, width: screenWidth/10, height: screenHeight/25)
        let iAmLabelLocationY = labelYPosition(label: iAmLabel)
        iAmLabel.text = "I am"
        iAmLabel.font = UIFont.boldSystemFont(ofSize: 14)
        iAmLabel.textColor = UIColor.black
        self.view.addSubview(iAmLabel)
        
        sleepingButton.frame = CGRect(x: 15, y: iAmLabelLocationY + screenHeight/36, width: screenWidth/3.5, height: screenHeight/25)
        let sleepingButtonLocationX = buttonXPosition(button: sleepingButton)
        let sleepingButtonLocationY = buttonYPosition(button: sleepingButton)
        sleepingButton.setTitle(" Sleeping", for: .normal)
        sleepingButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        sleepingButton.setTitleColor(UIColor.black, for: .normal)
        sleepingButton.setImage(UIImage(named: "Icon_Sleeping man.png"), for: .normal)
        sleepingButton.layer.borderWidth = 2.0
        sleepingButton.layer.cornerRadius = 10
        sleepingButton.layer.borderColor = UIColor.black.cgColor
        sleepingButton.addTarget(self, action: #selector(selectOrDeselectIAmButtons(_:)), for: .touchUpInside)
        self.view.addSubview(sleepingButton)
        
        
        workingButton.frame = CGRect(x: sleepingButtonLocationX + screenWidth/36, y: iAmLabelLocationY + screenHeight/36, width: screenWidth/3.5, height: screenHeight/25)
        let workingButtonLocationX = buttonXPosition(button: workingButton)
        let workingButtonLocationY = buttonYPosition(button: workingButton)
        workingButton.setTitle(" Working", for: .normal)
        workingButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        workingButton.setTitleColor(UIColor.black, for: .normal)
        workingButton.setImage(UIImage(named: "Icon_Working man.png"), for: .normal)
        workingButton.layer.borderWidth = 2.0
        workingButton.layer.cornerRadius = 10
        workingButton.layer.borderColor = UIColor.black.cgColor
        workingButton.addTarget(self, action: #selector(selectOrDeselectIAmButtons(_:)), for: .touchUpInside)
        self.view.addSubview(workingButton)
        
        
        restingButton.frame = CGRect(x: workingButtonLocationX + screenWidth/36, y: iAmLabelLocationY + screenHeight/36, width: screenWidth/3.5, height: screenHeight/25)
        let restingButtonLocationY = buttonYPosition(button: restingButton)
        restingButton.setTitle(" Resting", for: .normal)
        restingButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        restingButton.setTitleColor(UIColor.black, for: .normal)
        restingButton.setImage(UIImage(named: "Icon_Resting man.png"), for: .normal)
        restingButton.layer.borderWidth = 2.0
        restingButton.layer.cornerRadius = 10
        restingButton.layer.borderColor = UIColor.black.cgColor
        restingButton.addTarget(self, action: #selector(selectOrDeselectIAmButtons(_:)), for: .touchUpInside)
        self.view.addSubview(restingButton)
        
        walkingButton.frame = CGRect(x: 15, y: sleepingButtonLocationY + screenHeight/30, width: screenWidth/3.5, height: screenHeight/25)
        let walkingButtonLocationY = buttonYPosition(button: walkingButton)
        walkingButton.setTitle(" Walking", for: .normal)
        walkingButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        walkingButton.setTitleColor(UIColor.black, for: .normal)
        walkingButton.setImage(UIImage(named: "Icon_Walking.png"), for: .normal)
        walkingButton.layer.borderWidth = 2.0
        walkingButton.layer.cornerRadius = 10
        walkingButton.layer.borderColor = UIColor.black.cgColor
        walkingButton.addTarget(self, action: #selector(selectOrDeselectIAmButtons(_:)), for: .touchUpInside)
        self.view.addSubview(walkingButton)
        
        parentingButton.frame = CGRect(x: workingButton.frame.origin.x, y: workingButtonLocationY + screenHeight/30, width: screenWidth/3.5, height: screenHeight/25)
        parentingButton.setTitle(" Parenting", for: .normal)
        parentingButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        parentingButton.setTitleColor(UIColor.black, for: .normal)
        parentingButton.setImage(UIImage(named: "Icon_Parenting.png"), for: .normal)
        parentingButton.layer.borderWidth = 2.0
        parentingButton.layer.cornerRadius = 10
        parentingButton.layer.borderColor = UIColor.black.cgColor
        parentingButton.addTarget(self, action: #selector(selectOrDeselectIAmButtons(_:)), for: .touchUpInside)
        self.view.addSubview(parentingButton)
        
        
        othersButton.frame = CGRect(x: restingButton.frame.origin.x, y: restingButtonLocationY + screenHeight/30, width: screenWidth/3.5, height: screenHeight/25)
        othersButton.setTitle("Other", for: .normal)
        othersButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        othersButton.setTitleColor(UIColor.black, for: .normal)
        othersButton.layer.borderWidth = 2.0
        othersButton.layer.cornerRadius = 10
        othersButton.layer.borderColor = UIColor.black.cgColor
        othersButton.addTarget(self, action: #selector(selectOrDeselectIAmButtons(_:)), for: .touchUpInside)
        self.view.addSubview(othersButton)
        
        
        let iAmFeelingLabel = UILabel.init()
        iAmFeelingLabel.frame = CGRect(x: 15, y: walkingButtonLocationY + screenHeight/30, width: screenWidth/3.5, height: screenHeight/25)
        
        let iAmFeelingLabelLocationY = labelYPosition(label: iAmFeelingLabel)
        iAmFeelingLabel.text = "I am feeling"
        iAmFeelingLabel.textColor = UIColor.black
        iAmFeelingLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.view.addSubview(iAmFeelingLabel)
        
        happyFaceButton.frame = CGRect(x: 15, y: iAmFeelingLabelLocationY + screenHeight/48, width: screenWidth/9, height: screenHeight/25)
        let happyFaceButtonLocationX = buttonXPosition(button: happyFaceButton)
        let happyFaceButtonLocationY = buttonYPosition(button: happyFaceButton)
        happyFaceButton.titleLabel?.text = "Happy"
        happyFaceButton.setBackgroundImage(UIImage(named: "Icon_Happy Face.png"), for: .normal)
        happyFaceButton.setTitleColor(UIColor.black, for: .normal)
        happyFaceButton.layer.borderWidth = 2.0
        happyFaceButton.layer.cornerRadius = 10
        happyFaceButton.layer.borderColor = UIColor.black.cgColor
        happyFaceButton.addTarget(self, action: #selector(selectOrDeselectFaces(_:)), for: .touchUpInside)
        curvingButtonRounder(button: happyFaceButton)
        self.view.addSubview(happyFaceButton)
        
        
        mehFaceButton.frame = CGRect(x: happyFaceButtonLocationX + screenWidth/20, y: iAmFeelingLabelLocationY + screenHeight/48, width: screenWidth/9, height: screenHeight/25)
        let mehFaceButtonLocationX = buttonXPosition(button: mehFaceButton)
        mehFaceButton.titleLabel?.text = "Meh"
        mehFaceButton.setTitleColor(UIColor.black, for: .normal)
        mehFaceButton.setBackgroundImage(UIImage(named: "Icon_meh face.png"), for: .normal)
        mehFaceButton.layer.borderWidth = 2.0
        mehFaceButton.layer.cornerRadius = 10
        mehFaceButton.layer.borderColor = UIColor.black.cgColor
        mehFaceButton.addTarget(self, action: #selector(selectOrDeselectFaces(_:)), for: .touchUpInside)
        curvingButtonRounder(button: mehFaceButton)
        self.view.addSubview(mehFaceButton)
        
        
        frustratedFaceButton.frame = CGRect(x: mehFaceButtonLocationX + screenWidth/20, y: iAmFeelingLabelLocationY + screenHeight/48, width: screenWidth/9, height: screenHeight/25)
        let frustratedFaceButtonLocationX = buttonXPosition(button: frustratedFaceButton)
        frustratedFaceButton.titleLabel?.text = "Frustrated"
        frustratedFaceButton.setTitleColor(UIColor.black, for: .normal)
        frustratedFaceButton.setBackgroundImage(UIImage(named: "Frustrated face.png"), for: .normal)
        frustratedFaceButton.layer.borderWidth = 2.0
        frustratedFaceButton.layer.cornerRadius = 10
        frustratedFaceButton.layer.borderColor = UIColor.black.cgColor
        frustratedFaceButton.addTarget(self, action: #selector(selectOrDeselectFaces(_:)), for: .touchUpInside)
        curvingButtonRounder(button: frustratedFaceButton)
        self.view.addSubview(frustratedFaceButton)
        
        
        angryFaceButton.frame = CGRect(x: frustratedFaceButtonLocationX + screenWidth/20, y: iAmFeelingLabelLocationY + screenHeight/48, width: screenWidth/9, height: screenHeight/25)
        let angryFaceButtonLocationX = buttonXPosition(button: angryFaceButton)
        angryFaceButton.titleLabel?.text = "Angry"
        angryFaceButton.setTitleColor(UIColor.black, for: .normal)
        angryFaceButton.setBackgroundImage(UIImage(named: "Icon_Angry Face.png"), for: .normal)
        angryFaceButton.layer.borderWidth = 2.0
        angryFaceButton.layer.cornerRadius = 10
        angryFaceButton.layer.borderColor = UIColor.black.cgColor
        angryFaceButton.addTarget(self, action: #selector(selectOrDeselectFaces(_:)), for: .touchUpInside)
        curvingButtonRounder(button: angryFaceButton)
        self.view.addSubview(angryFaceButton)
        
        annoyedFaceButton.frame = CGRect(x: angryFaceButtonLocationX + screenWidth/20, y: iAmFeelingLabelLocationY + screenHeight/48, width: screenWidth/9, height: screenHeight/25)
        let annoyedFaceButtonLocationX = buttonXPosition(button: annoyedFaceButton)
        annoyedFaceButton.titleLabel?.text = "Annoyed"
        annoyedFaceButton.setTitleColor(UIColor.black, for: .normal)
        annoyedFaceButton.setBackgroundImage(UIImage(named: "Icon_Annoyed Face.png"), for: .normal)
        annoyedFaceButton.layer.borderWidth = 2.0
        annoyedFaceButton.layer.cornerRadius = 10
        annoyedFaceButton.layer.borderColor = UIColor.black.cgColor
        annoyedFaceButton.addTarget(self, action: #selector(selectOrDeselectFaces(_:)), for: .touchUpInside)
        curvingButtonRounder(button: annoyedFaceButton)
        self.view.addSubview(annoyedFaceButton)
        
        
        dizzyFaceButton.frame = CGRect(x: annoyedFaceButtonLocationX + screenWidth/20, y: iAmFeelingLabelLocationY + screenHeight/48, width: screenWidth/9, height: screenHeight/25)
        dizzyFaceButton.titleLabel?.text = "Dizzy"
        dizzyFaceButton.setTitleColor(UIColor.black, for: .normal)
        dizzyFaceButton.setBackgroundImage(UIImage(named: "Icon_Dizzy Face.png"), for: .normal)
        dizzyFaceButton.layer.borderWidth = 2.0
        dizzyFaceButton.layer.cornerRadius = 10
        dizzyFaceButton.layer.borderColor = UIColor.black.cgColor
        dizzyFaceButton.addTarget(self, action: #selector(selectOrDeselectFaces(_:)), for: .touchUpInside)
        curvingButtonRounder(button: dizzyFaceButton)
        self.view.addSubview(dizzyFaceButton)
        
        
        identifyNoiseSourceButton.frame = CGRect(x: 15, y: happyFaceButtonLocationY + screenHeight/30, width: screenWidth - 30, height: screenHeight/25)
        identifyNoiseSourceButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        identifyNoiseSourceButton.setTitleColor(UIColor.black, for: .normal)
        identifyNoiseSourceButton.setTitle("Locate the noise", for: .normal)
        identifyNoiseSourceButton.layer.borderWidth = 2.0
        identifyNoiseSourceButton.layer.cornerRadius = 10
        identifyNoiseSourceButton.layer.borderColor = UIColor.black.cgColor
        identifyNoiseSourceButton.addTarget(self, action: #selector(locateTheNoise(_:)), for: .touchUpInside)
        self.view.addSubview(identifyNoiseSourceButton)
        
        print(newTask.value(forKey: "reportAddress"), "slideupview")
        
        
    }
    //noise type buttons
    @objc func noiseTypeButtonsSelect(_ sender: UIButton) {
        //all the buttons have a background color of white and are not selected
        sender.setTitleColor(UIColor.black, for: .normal)
        noiseTypeArray.forEach({ $0.tintColor = UIColor.clear
            $0.backgroundColor = nil
            sender.isSelected = false
        })
        
        //when a button is pressed, the background color changes to the custom color below. Is selected and only 1 button is selected at 1 time
        sender.setTitleColor(UIColor.black, for: .selected)
        sender.backgroundColor = UIColor.buttonSelected()
        sender.isSelected = true
        
        //saving button information in core data
        newTask.setValue(sender.titleLabel?.text, forKey: "noiseType")
//        savingData()
//        let _ = navigationController?.popViewController(animated: true)
    }
    
    //    //for the first row of buttons, home or elsewhere
    @objc func selectOrDeselect(_ sender: UIButton) {
        //all the buttons have a background color of white and are not selected
        locationButtonArray.forEach({ $0.backgroundColor = UIColor.white
            sender.isSelected = false
        })
        
        //when a button is pressed, the background color changes to the custom color below. Is selected and only 1 button is selected at 1 time
        sender.backgroundColor = UIColor.buttonSelected()
        sender.isSelected = true
        
        //saving button information in core data
        newTask.setValue(sender.title(for: .normal), forKey: "inOrOut")
//        savingData()
//        let _ = navigationController?.popViewController(animated: true)
    }
    //
    //    //for the second row of buttons, I am section of buttons
    @objc func selectOrDeselectIAmButtons(_ sender: UIButton) {
        //all the buttons have a background color of white and are not selected
        iAmButtonsArray.forEach({ $0.backgroundColor = UIColor.white
            sender.isSelected = false
            if sender == sleepingButton{
                sender.setImage(UIImage(named:"Icon_Sleeping man.png"), for: .normal)
            }
        })
        //when a button is pressed, the background color changes to the custom color below. Is selected and only 1 button is selected at 1 time
        sender.backgroundColor = UIColor.buttonSelected()
        sender.isSelected = true
        if sender == sleepingButton{
            sender.setImage(UIImage(named:"Logo_Sleeping Man.png"), for: [.highlighted, .selected])
        }
        
        //saving button information in core data
        newTask.setValue(sender.title(for: .normal), forKey: "iAm")
//        savingData()
//        let _ = navigationController?.popViewController(animated: true)
    }
    //
    //
    //the face buttons
    @objc func selectOrDeselectFaces(_ sender: UIButton) {
        
        sender.layer.borderWidth = 2
        
        //all the buttons have a border color of gray and are not selected
        faceButtonArray.forEach({ $0.layer.borderColor = UIColor.black.cgColor
            sender.isSelected = false
        })
        
        //when a button is pressed, the border color changes to the custom color below. Is selected and only 1 button is selected at 1 time
        sender.layer.borderColor = UIColor.faceSelected().cgColor
        sender.isSelected = true
        
        //saving button information in core data
        newTask.setValue(sender.titleLabel?.text, forKey: "faceButton")
//        savingData()
//        let _ = navigationController?.popViewController(animated: true)
    }
    //
    //    //locate the noise button action
    @objc func locateTheNoise(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "map") ; // details the storyboard ID
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil);
//        savingData()
//        let _ = navigationController?.popViewController(animated: true)
    }
    
}
