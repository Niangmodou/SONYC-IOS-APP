//
//  SlideUpView.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 7/23/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//
import UIKit

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
     
        
        addingBorder(button: homeButton)
        addingBorder(button: elsewhereButton)
        addingBorder(button: sleepingButton)
        addingBorder(button: parentingButton)
        addingBorder(button: workingButton)
        addingBorder(button: othersButton)
        addingBorder(button: restingButton)
        addingBorder(button: walkingButton)
        addingBorder(button: identifyNoiseSourceButton)
        
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
    
    
    @IBAction func selectOrDeselect(_ sender: UIButton) {
        locationButtonArray.forEach({ $0.backgroundColor = UIColor.white})
            sender.backgroundColor = UIColor.buttonSelected()
        if sender == homeButton{
            
        }
        else if sender == elsewhereButton{
                  
              }
    }
    @IBAction func selectOrDeselectIAmButtons(_ sender: UIButton) {
          iAmButtonsArray.forEach({ $0.backgroundColor = UIColor.white})
              sender.backgroundColor = UIColor.buttonSelected()
        if sender == sleepingButton{
                  sender.setImage(UIImage(named:"Logo_Sleeping Man.png"), for: [.highlighted, .selected])
              }
        if sender == parentingButton{
                  
              }
        if sender == workingButton{
                  
              }
        if sender == walkingButton{
                  
              }
        if sender == othersButton{
                  
              }
        if sender == restingButton{
                  
              }
      }
    
    @IBAction func selectOrDeselectFaces(_ sender: UIButton) {
        sender.layer.borderWidth = 2
        faceButtonArray.forEach({ $0.layer.borderColor = UIColor.gray.cgColor})
        sender.layer.borderColor = UIColor.faceSelected().cgColor
        
        
        
        if sender == mehFaceButton{
                  
              }
        if sender == dizzyFaceButton{
                  
              }
        if sender == annoyedFaceButton{
                  
              }
        if sender == angryFaceButton{
                  
              }
        if sender == happyFaceButton{
                  
              }
        if sender == frustratedFaceButton{
                  
              }
          }
    
    
  

}
