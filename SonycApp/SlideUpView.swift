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

class SlideUpView: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    
    
    @IBOutlet weak var middleView: UIView!
    
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var elsewhereButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var sleepingButton: UIButton!
    
    @IBOutlet weak var parentingButton: UIButton!
    @IBOutlet weak var workingButton: UIButton!
    
    @IBOutlet weak var othersButton: UIButton!
    @IBOutlet weak var restingButton: UIButton!
    
    @IBOutlet weak var walkingButton: UIButton!
    
    @IBOutlet weak var mehFaceButton: UIButton!
    
    @IBOutlet weak var dizzyFaceButton: UIButton!
    @IBOutlet weak var annoyedFaceButton: UIButton!
    @IBOutlet weak var angryFaceButton: UIButton!
    @IBOutlet weak var frustratedFaceButton: UIButton!
    @IBOutlet weak var happyFaceButton: UIButton!
    
    @IBOutlet var locationButtonArray: [UIButton]!
    @IBOutlet var iAmButtonsArray: [UIButton]!
    
    @IBOutlet var faceButtonArray: [UIButton]!
    
    
    @IBOutlet weak var identifyNoiseSourceButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //
        //button styling
        curvingButton(button: homeButton)
        curvingButton(button: elsewhereButton)
        curvingButton(button: sleepingButton)
        curvingButton(button: parentingButton)
        curvingButton(button: workingButton)
        curvingButton(button: othersButton)
        curvingButton(button: restingButton)
        curvingButton(button: walkingButton)
        curvingButtonRounder(button: mehFaceButton)
        curvingButtonRounder(button: dizzyFaceButton)
        curvingButtonRounder(button: annoyedFaceButton)
        curvingButtonRounder(button: angryFaceButton)
        curvingButtonRounder(button: frustratedFaceButton)
        curvingButtonRounder(button: happyFaceButton)
        curvingButtonRounder(button: identifyNoiseSourceButton)
        
        //adding borders
        addingBorder(button: homeButton)
        addingBorder(button: elsewhereButton)
        addingBorder(button: sleepingButton)
        addingBorder(button: parentingButton)
        addingBorder(button: workingButton)
        addingBorder(button: othersButton)
        addingBorder(button: restingButton)
        addingBorder(button: walkingButton)
        addingBorder(button: identifyNoiseSourceButton)
        
        //adding border colors
        addingBorderColorBlack(button: homeButton)
        addingBorderColorBlack(button: elsewhereButton)
        addingBorderColorBlack(button: sleepingButton)
        addingBorderColorBlack(button: parentingButton)
        addingBorderColorBlack(button: workingButton)
        addingBorderColorBlack(button: othersButton)
        addingBorderColorBlack(button: restingButton)
        addingBorderColorBlack(button: walkingButton)
        addingBorderColorBlack(button: identifyNoiseSourceButton)
        
        myView.roundCorners(cornerRadius: 20.0)
        
    }
    
    //for the first row of buttons, home or elsewhere
    @IBAction func selectOrDeselect(_ sender: UIButton) {
        //all the buttons have a background color of white and are not selected
        locationButtonArray.forEach({ $0.backgroundColor = UIColor.white
            sender.isSelected = false
        })
        
        //when a button is pressed, the background color changes to the custom color below. Is selected and only 1 button is selected at 1 time
        sender.backgroundColor = UIColor.buttonSelected()
        sender.isSelected = true
        
        //saving button information in core data
        newTask.setValue(sender.title(for: .normal), forKey: "inOrOut")
        savingData()
        let _ = navigationController?.popViewController(animated: true)
    }
    
    //for the second row of buttons, I am section of buttons
    @IBAction func selectOrDeselectIAmButtons(_ sender: UIButton) {
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
        savingData()
        let _ = navigationController?.popViewController(animated: true)
    }
    
    
    //the face buttons
    @IBAction func selectOrDeselectFaces(_ sender: UIButton) {
        
        sender.layer.borderWidth = 2
        
        //all the buttons have a border color of gray and are not selected
        faceButtonArray.forEach({ $0.layer.borderColor = UIColor.gray.cgColor
            sender.isSelected = false
        })
        
        //when a button is pressed, the border color changes to the custom color below. Is selected and only 1 button is selected at 1 time
        sender.layer.borderColor = UIColor.faceSelected().cgColor
        sender.isSelected = true
        
        //saving button information in core data
        newTask.setValue(sender.title(for: .normal), forKey: "faceButton")
        savingData()
        let _ = navigationController?.popViewController(animated: true)
    }
    
    //locate the noise button action
    @IBAction func locateTheNoise(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "details") ; // details the storyboard ID
        self.present(vc, animated: true, completion: nil);
        savingData()
        let _ = navigationController?.popViewController(animated: true)
        
        
    }
    
    
}
