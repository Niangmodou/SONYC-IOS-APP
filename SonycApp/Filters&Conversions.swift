//
//  Filters&Conversions.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 7/25/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//

import UIKit
import Accelerate
import AudioToolbox
import AVFoundation

//credit to https://developer.apple.com/documentation/accelerate/equalizing_audio_with_vdsp for the 6 values below

//Object for forward DCT operation
//forward transform (type II)
let forwardDCT = vDSP.DCT(count:  bufferSize,
                          transformType: .II)

//Object for inverse DCT operation
//inverse transform (type III)
let inverseDCT = vDSP.DCT(count: bufferSize,
                          transformType: .III)



var forwardDCT_PreProcessed = [Float](repeating: 0,
                                      count: bufferSize)

var forwardDCT_PostProcessed = [Float](repeating: 0,
                                       count: bufferSize)

var inverseDCT_Result = [Float](repeating: 0,
                                count: bufferSize)

class FiltersConversions: UIViewController{
    
}

//equalizes the audio using a DCT-based filter
//applies the a-weighted filter
//this function up to the array called values, will be credited to: https://developer.apple.com/documentation/accelerate/equalizing_audio_with_vdsp
//takes in a float array and returns a float array. (takes in the audio sample array)
func apply(dctMultiplier: [Float], toInput input: [Float]) -> [Float] {
    // Perform forward DCT.
    forwardDCT?.transform(input,
                          result: &forwardDCT_PreProcessed)
    // Multiply frequency-domain data by (`dctMultiplier`-> filter values).
    vDSP.multiply(dctMultiplier,
                  forwardDCT_PreProcessed,
                  result: &forwardDCT_PostProcessed)
    
    // Perform inverse DCT.
    inverseDCT?.transform(forwardDCT_PostProcessed,
                          result: &inverseDCT_Result)
    
    // In-place scale inverse DCT result by n / 2.
    // Output samples are now in range -1...+1
    vDSP.divide(inverseDCT_Result,
                Float(bufferSize/2),
                result: &inverseDCT_Result)
    
    return inverseDCT_Result
}

//gets the average of the decibels
//takes in a float array and returns an int, the average of the array
func applyMean(toInput input: [Float]) -> Float{
    
    //adds up the entered array
    let sumArray = input.reduce(0, +)
    
    //calculates the average of the array by dividing the sum by the amount of values in the inputted array
    let avgArrayValue = sumArray / Float(input.count)
    //converts to integer
    //    let intAvgArrayValue = Int(avgArrayValue)
    
    return avgArrayValue
    //    return intAvgArrayValue
    
}


//finishes the calculation of the decibels (sound pressure levels)
//takes in a float array and returns a float array
func decibelsConvert(array: [Float]) -> [Float]{
    
    //a new array that has the squares all the values in the audio sample array to make sure they are all positive later on
    var values: [Float] = array
    values.enumerated().forEach{ index, value in
        values[index] = powf(value, 2.0)
    }
    
    //a new array that has the square root values of the squared ones beforehand^
    var values1: [Float] = values
    values1.enumerated().forEach{ index, value in
        values1[index] = sqrtf(value)
    }
    
    
    // a new array that calculates the log of the previous values.
    var values2: [Float] = values1
    values2.enumerated().forEach{ index, value in
        values2[index] = log10(value)
    }
    
    //array that stores value from the inputted array multipled by 20
    var dbs: [Float] = values2
    dbs.enumerated().forEach{ index, value in
        dbs[index] =  20 * value
    }
    
    //array that adds the offset to each value from the previous array (dbs)
    var dbs1: [Float] = dbs
    dbs1.enumerated().forEach{ index, value in
        dbs1[index] =  value + Float(calibrationOffset)
        
    }
    
    //absolute value of each value from previous array (dbs1)
    var dbs3: [Float] = dbs1
    dbs3.enumerated().forEach{ index, value in
        dbs3[index] =  abs(value)
    }
    return dbs3
    
}
//getDirectiory of the file url
func getDirectory() -> URL{
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = paths[0]
    return documentDirectory
}



